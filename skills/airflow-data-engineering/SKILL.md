---
name: airflow-data-engineering
description: Unified Airflow workflow covering DAG authoring, local testing, debugging, plugin patterns, HITL workflows, and Airflow 2 to 3 migration.
---

# Airflow Data Engineering

Use this skill as the default for Airflow-centric engineering work.

## Trigger

Use this skill when:
- You need to author or modify DAGs
- You need to test or debug DAG/task failures
- You need plugin-level extensions or custom Airflow integration behavior
- You need human-in-the-loop branching and approval patterns
- You need migration guidance from Airflow 2.x to 3.x

Do not use this skill when:
- The request is purely dbt modeling with no Airflow orchestration concern
- The request is only warehouse SQL analysis

## Workflow

1. Scope and runtime context
   - Capture DAG objective, schedule, SLAs, and dependencies
   - Confirm Airflow version, executor/runtime, and deployment boundaries
2. Author DAG changes
   - Prefer composable tasks, explicit retries/timeouts, and idempotent task logic
   - Ensure contracts for inputs, outputs, and failure behavior
3. Test locally
   - Run focused DAG parse/import checks and targeted task tests
   - Validate task dependencies and branching behavior
4. Debug failures
   - Inspect logs, task instance context, and upstream/downstream dependencies
   - Isolate root cause before proposing fixes
5. Extend and migrate
   - Apply plugin patterns only when standard operators are insufficient
   - For Airflow 2 to 3 migration, stage changes with compatibility checks

## Output Contract

Return results with:
- DAG/task changes and rationale
- Test/debug evidence with root cause summary
- Migration or rollout risks and rollback plan

## Sources Merged

This skill consolidates scope from:
- airflow
- authoring-dags
- testing-dags
- debugging-dags
- airflow-plugins
- airflow-hitl
- migrating-airflow-2-to-3