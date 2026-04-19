---
name: dbt-analytics-engineering
description: Unified dbt workflow for analytics engineering, command execution, semantic layer, testing, troubleshooting, docs access, and migration patterns.
---

# dbt Analytics Engineering

Use this skill as the primary entrypoint for dbt-related work.

## Trigger

Use this skill when:
- You need to build or modify dbt models and tests
- You need the right dbt command workflow for local or CI execution
- You need semantic layer entities, dimensions, measures, or metrics
- You need to troubleshoot dbt failures from logs and run metadata
- You need dbt migration guidance (Core to Fusion or platform migration)
- You need Cosmos guidance for running dbt inside Airflow

Do not use this skill when:
- The request is Airflow-only without dbt context
- The request is warehouse analysis with no dbt project scope

## Workflow

1. Discover project state
   - Identify adapters, profiles, targets, and model graph boundaries
   - Confirm environment and credentials required for execution
2. Implement or update models
   - Encode clear grain, keys, and dependency contracts
   - Add schema, data, and unit tests with realistic mocks
3. Execute commands safely
   - Choose selectors and commands that minimize blast radius
   - Run parse/compile/build/test sequence based on change scope
4. Troubleshoot and iterate
   - Use logs/artifacts to isolate failing nodes and root causes
   - Fix model logic or environment config with explicit verification
5. Handle docs, semantics, and migration
   - Update docs and semantic layer definitions where impacted
   - Plan migrations with compatibility checks and rollback points

## Output Contract

Return results with:
- Models/tests/commands changed
- Execution evidence and failure root cause notes
- Semantic layer or documentation deltas
- Migration risks and phased rollout plan

## Sources Merged

This skill consolidates scope from:
- using-dbt-for-analytics-engineering
- running-dbt-commands
- adding-dbt-unit-test
- troubleshooting-dbt-job-errors
- building-dbt-semantic-layer
- answering-natural-language-questions-with-dbt
- fetching-dbt-docs
- configuring-dbt-mcp-server
- migrating-dbt-core-to-fusion
- migrating-dbt-project-across-platforms
- cosmos-dbt-core
- cosmos-dbt-fusion