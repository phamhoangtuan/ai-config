---
name: diagnose
description: Disciplined diagnosis loop for hard bugs and pipeline failures. Reproduce → minimise → hypothesise → instrument → fix → regression-test. Use when user says "diagnose this" / "debug this", reports a bug, says something is broken/failing/producing wrong data, or describes a performance regression. Core DE use cases: DAG task failures, wrong aggregation output, CDC lag, Spark OOM, dbt model errors, warehouse query slowness.
origin: mattpocock/skills (adapted for data engineering)
---

# Diagnose

A discipline for hard bugs and pipeline failures. Skip phases only when explicitly justified.

When exploring the codebase, use the project's domain glossary to get a clear mental model of the relevant modules, and check ADRs in the area you're touching.

## Phase 1 — Build a feedback loop

**This is the skill.** Everything else is mechanical. If you have a fast, deterministic, agent-runnable pass/fail signal for the bug, you will find the cause — bisection, hypothesis-testing, and instrumentation all just consume that signal. If you don't have one, no amount of staring at code will save you.

Spend disproportionate effort here. **Be aggressive. Be creative. Refuse to give up.**

### Ways to construct one — try them in roughly this order

**General (all systems):**

1. **Failing test** at whatever seam reaches the bug — unit, integration, e2e.
2. **CLI invocation** with a fixture input, diffing stdout against a known-good snapshot.
3. **Replay a captured trace.** Save a real event log / payload / query result to disk; replay it through the code path in isolation.
4. **Throwaway harness.** Spin up a minimal subset of the system (one task, mocked deps) that exercises the bug code path with a single function call.
5. **Property / fuzz loop.** If the bug is "sometimes wrong output", run 1000 random inputs and look for the failure mode.
6. **Bisection harness.** If the bug appeared between two known states (commit, dataset version, partition date), automate "boot at state X, check, repeat" so you can bisect it.
7. **Differential loop.** Run the same input through old-version vs new-version (or two configs) and diff outputs.
8. **HITL bash script.** Last resort when a human must interact with an external system to reproduce.

**Data Engineering specific:**

9. **Backfill a single partition.** For DAG/pipeline bugs, re-run just one date partition in isolation: `airflow tasks test <dag> <task> <execution_date>`. This produces a fast, deterministic pass/fail signal without full DAG overhead.
10. **dbt unit test / compile check.** For dbt model bugs: `dbt test --select <model>` or `dbt compile --select <model>` to isolate the SQL before running against the warehouse.
11. **Query replay.** Capture the exact SQL a failed pipeline emitted (from query logs or `dbt debug`), run it manually against the warehouse, and inspect intermediate results with `LIMIT 100`.
12. **Schema diff.** For "wrong data" bugs, diff the actual output schema against the expected schema: column names, types, nullability, row counts. A schema mismatch explains 40% of DE bugs.
13. **Upstream data audit.** Run a quick profile (row count, null rate, min/max) on the upstream source table for the failing execution window. Silent upstream schema changes are the #1 cause of unexplained pipeline failures in bank environments.
14. **Idempotency check.** Run the same pipeline task twice on the same input. If outputs differ, the task is non-idempotent — that's the bug pattern, not the symptom.
15. **Lineage trace.** Use `lineage-ops` skill to trace upstream dependencies of the failing model/table. The real failure often originates 2–3 hops upstream.

Build the right feedback loop, and the bug is 90% fixed.

### Iterate on the loop itself

Treat the loop as a product. Once you have _a_ loop, ask:

- Can I make it faster? (Cache setup, skip unrelated init, narrow the partition window.)
- Can I make the signal sharper? (Assert on the specific symptom — a row count, a null rate, a specific value — not "didn't crash".)
- Can I make it more deterministic? (Pin the execution date, use a fixed seed dataset, isolate from upstream changes.)

A 30-second flaky loop is barely better than no loop. A 2-second deterministic loop is a debugging superpower.

### Non-deterministic bugs

The goal is not a clean repro but a **higher reproduction rate**. Run the trigger 100×, narrow timing windows, inject delay. A 50%-flake is debuggable; 1% is not — keep raising the rate.

### When you genuinely cannot build a loop

Stop and say so explicitly. List what you tried. Ask the user for: (a) access to the environment that reproduces it, (b) captured artifacts (query logs, Airflow task logs, Spark event logs, warehouse query history), or (c) permission to add temporary instrumentation. Do **not** proceed to hypothesise without a loop.

Do not proceed to Phase 2 until you have a loop you believe in.

---

## Phase 2 — Reproduce

Run the loop. Watch the bug appear.

Confirm:

- [ ] The loop produces the failure mode the **user** described — not a different failure nearby. Wrong bug = wrong fix.
- [ ] The failure is reproducible across multiple runs (or at a high enough rate for non-deterministic bugs).
- [ ] You have captured the exact symptom (error message, wrong row count, wrong aggregate value, slow query plan) so later phases can verify the fix addresses it.

Do not proceed until you reproduce the bug.

---

## Phase 3 — Hypothesise

Generate **3–5 ranked hypotheses** before testing any of them. Single-hypothesis generation anchors on the first plausible idea.

Each hypothesis must be **falsifiable**: state the prediction it makes.

> Format: "If \<X\> is the cause, then \<changing Y\> will make the bug disappear / \<changing Z\> will make it worse."

If you cannot state the prediction, the hypothesis is a vibe — discard or sharpen it.

**Show the ranked list to the user before testing.** They often have domain knowledge that re-ranks instantly ("we just deployed a schema change to that upstream table"), or know hypotheses already ruled out. Cheap checkpoint, big time saver. Don't block on it — proceed with your ranking if the user is AFK.

**Common DE hypotheses to consider:**

- Upstream schema changed silently (column dropped, type changed, renamed)
- Partition filter is wrong — query pulls wrong date range
- Timezone handling mismatch (UTC vs local) causing off-by-one partition
- Duplicate keys in source producing fan-out in joins
- NULL handling difference between SQL dialects (e.g. Spark vs Postgres)
- DAG trigger time vs data availability window mismatch
- Incremental logic bug — full refresh would pass, incremental breaks
- Stale dbt manifest / compiled artifacts out of sync with source changes

---

## Phase 4 — Instrument

Each probe must map to a specific prediction from Phase 3. **Change one variable at a time.**

Tool preference:

1. **Direct SQL inspection** at intermediate materialization points. One targeted query beats ten log lines.
2. **Targeted logs** at task boundaries that distinguish hypotheses.
3. Never "log everything and grep".

**Tag every debug log** with a unique prefix, e.g. `[DEBUG-a4f2]`. Cleanup at the end becomes a single grep. Untagged logs survive; tagged logs die.

**Perf branch.** For performance regressions (slow DAG, slow query, Spark OOM):
- Establish a baseline measurement (query plan, Spark UI, timing harness) before changing anything.
- Bisect the execution plan: isolate which stage/step is slow.
- Measure first, fix second.

---

## Phase 5 — Fix + regression test

Write the regression test **before the fix** — but only if there is a **correct seam** for it.

A correct seam is one where the test exercises the **real bug pattern**. If the only available seam is too shallow (e.g., a unit test on a transform function when the bug is in how partitions are joined), a regression test there gives false confidence.

**DE-specific regression test options:**

- **dbt unit test**: add a `dbt test` or dbt unit test YAML for the exact input/output pattern that failed.
- **pytest on the transform function**: for pandas/Polars/PySpark transforms, write a pytest that feeds the exact fixture data that triggered the bug.
- **SQL assertion**: add a Great Expectations expectation or a `dbt test` assertion that would have caught this (e.g., `not_null`, `unique`, `accepted_values`, `expression_is_true`).
- **DAG-level smoke test**: add an Airflow test that replays the task with a captured fixture input.

If no correct seam exists, **that itself is the finding.** The pipeline architecture is preventing the bug from being locked down. Flag this and hand off to `improve-pipeline-architecture` skill.

If a correct seam exists:

1. Turn the minimised repro into a failing test at that seam.
2. Watch it fail.
3. Apply the fix.
4. Watch it pass.
5. Re-run the Phase 1 feedback loop against the original (un-minimised) scenario.

---

## Phase 6 — Cleanup + post-mortem

Required before declaring done:

- [ ] Original repro no longer reproduces (re-run Phase 1 loop)
- [ ] Regression test passes (or absence of seam is documented)
- [ ] All `[DEBUG-...]` instrumentation removed
- [ ] Throwaway SQL/scripts deleted (or moved to a clearly-marked debug location)
- [ ] The hypothesis that turned out correct is stated in the commit / PR message

**Then ask: what would have prevented this bug?**

- No good test seam → flag for `improve-pipeline-architecture`
- Missing upstream contract → flag for a data contract between producer and consumer
- Missing data quality check → add a Great Expectations / dbt test assertion to catch this class of bug proactively
- No lineage visibility → flag for `lineage-ops` to annotate this path
