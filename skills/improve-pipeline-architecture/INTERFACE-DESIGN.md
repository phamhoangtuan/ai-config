# Interface Design for Pipeline Modules

When the user wants to explore alternative interfaces for a chosen deepening candidate, use this parallel sub-agent pattern. Based on "Design It Twice" (Ousterhout) — your first idea is unlikely to be the best.

Uses the vocabulary in [LANGUAGE.md](LANGUAGE.md) — **module**, **interface**, **seam**, **adapter**, **leverage**.

---

## Process

### 1. Frame the problem space

Before spawning sub-agents, write a user-facing explanation of the problem space for the chosen candidate:

- The constraints any new interface would need to satisfy
- The dependencies it would rely on, and which category they fall into (see [DEEPENING.md](DEEPENING.md))
- A rough illustrative code or schema sketch to ground the constraints — not a proposal, just a way to make the constraints concrete

Show this to the user, then immediately proceed to Step 2. The user reads and thinks while the sub-agents work in parallel.

### 2. Spawn sub-agents

Spawn 3+ sub-agents in parallel. Each must produce a **radically different** interface for the deepened pipeline module.

Give each sub-agent a different design constraint:

- **Agent 1**: "Minimize the interface — aim for 1–3 entry points max. Maximize leverage per entry point."
- **Agent 2**: "Maximize flexibility — support many pipeline use cases and downstream consumers."
- **Agent 3**: "Optimize for the most common caller — make the default pipeline invocation trivial."
- **Agent 4** (if applicable): "Design around ports & adapters for cross-boundary dependencies (e.g., warehouse, Kafka, external API)."

Include [LANGUAGE.md](LANGUAGE.md) vocabulary and the project's domain vocabulary in each brief.

Each sub-agent outputs:

1. Interface (function signatures, DataFrame contracts, schema — plus invariants, ordering, error modes)
2. Usage example showing how a DAG task or dbt model calls it
3. What the implementation hides behind the seam
4. Dependency strategy and adapters (see [DEEPENING.md](DEEPENING.md))
5. Trade-offs — where leverage is high, where it's thin

### 3. Present and compare

Present designs sequentially so the user can absorb each one, then compare them in prose. Contrast by **depth** (leverage at the interface), **locality** (where change concentrates), and **seam placement**.

After comparing, give your own recommendation: which design is strongest and why. If elements from different designs would combine well, propose a hybrid. Be opinionated.

---

## DE-specific interface design considerations

When designing interfaces for pipeline modules, also consider:

- **Partition/window semantics**: does the interface make the time window explicit (`process(date: date)`) or implicit (caller must configure it elsewhere)? Explicit is almost always better for testability.
- **Schema contract at the seam**: what is the output schema? Is it typed (Pydantic, dataclass, dbt model YAML) or implicit (raw DataFrame)? Typed contracts make the seam real.
- **Idempotency guarantee**: does the interface guarantee idempotent execution? If `write_partition(df, date)` is called twice, what happens? This should be part of the interface contract, not an implementation detail.
- **Error surface**: what does the interface raise or return on failure? A shallow interface lets warehouse exceptions propagate raw. A deep interface translates them into domain errors (`PartitionNotFound`, `SchemaContractViolation`).
