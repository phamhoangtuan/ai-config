---
name: improve-pipeline-architecture
description: Find deepening opportunities in a data pipeline codebase. Surface shallow modules, tightly-coupled DAGs, untestable transforms, and wide interfaces. Use when the user wants to refactor pipelines, improve testability, reduce coupling between Airflow/dbt/Spark layers, or make a DE codebase more maintainable and AI-navigable.
origin: mattpocock/skills (adapted for data engineering)
---

# Improve Pipeline Architecture

Surface architectural friction and propose **deepening opportunities** — refactors that turn shallow pipeline modules into deep ones. The aim is testability, maintainability, and AI-navigability of data pipelines.

## Glossary

Use the terms in [LANGUAGE.md](LANGUAGE.md) exactly. Don't drift into "service," "component," "step," or "layer" unless they map precisely to a defined term.

Key terms: **module**, **interface**, **depth**, **seam**, **adapter**, **leverage**, **locality**.

DE-specific additions:

- **Pipeline module** — anything in a data pipeline with an interface and an implementation: a dbt model, an Airflow operator wrapper, a PySpark transform function, a Great Expectations suite, a Polars transformation chain.
- **Contract** — the explicit schema agreement between a producer module and a consumer module. A contract is the interface between pipeline stages.
- **Materialisation** — a concrete output artifact at a seam (a table, a Parquet file, a Kafka topic). The seam is where the materialisation lives.
- **Orchestration layer** — Airflow/Prefect/Dagster DAG definitions. Should be thin: scheduling, dependency, retry logic only. Business logic does not belong here.
- **Transform layer** — the functions, dbt models, or Spark jobs that apply business logic to data. The deepest modules live here.
- **Ingestion layer** — extractors, readers, CDC connectors. Should expose a simple interface: give me rows for this window/partition.

## Process

### 1. Explore

Read the project's domain glossary and any ADRs in the area you're touching first.

Use explore agents to walk the pipeline codebase. Don't follow rigid heuristics — explore organically and note where you experience friction:

- Where does understanding one pipeline concept require reading across many files (DAG, operator, transform, test)?
- Where are pipeline modules **shallow** — the caller has to know as much as the implementation to use it?
- Where is business logic buried inside Airflow DAG definitions instead of in testable transform functions?
- Where do dbt models carry so much logic that `dbt test` is the only way to verify them?
- Where do Spark jobs mix ingestion, transformation, and writing in one file?
- Which pipeline stages have no tests, or are only testable by running the full pipeline end-to-end?
- Where does a change in one layer (e.g., source schema) ripple through N downstream modules without a contract to catch it?

Apply the **deletion test** to anything you suspect is shallow: would deleting it concentrate complexity, or just move it? "Yes, concentrates" is the signal you want.

### 2. Present candidates

Present a numbered list of deepening opportunities. For each candidate:

- **Files** — which files/modules are involved
- **Problem** — why the current architecture is causing friction
- **Solution** — plain English description of what would change
- **Benefits** — explained in terms of locality and leverage, and how tests would improve

**Use the project's domain vocabulary for data concepts, and [LANGUAGE.md](LANGUAGE.md) vocabulary for architecture.** If the domain defines "transaction," talk about "the transaction ingestion module" — not "the ETL step."

**ADR conflicts**: if a candidate contradicts an existing ADR, only surface it when the friction is real enough to warrant revisiting. Mark it clearly.

Do NOT propose interfaces yet. Ask: "Which of these would you like to explore?"

### 3. Grilling loop

Once the user picks a candidate, drop into a grilling conversation. Walk the design tree — constraints, dependencies, the shape of the deepened module, what sits behind the seam, what tests survive.

Side effects happen inline as decisions crystallise:

- **Naming a deepened module after a concept not in the domain glossary?** Add it.
- **User rejects the candidate with a load-bearing reason?** Offer an ADR.
- **Want to explore alternative interfaces for the deepened module?** See [INTERFACE-DESIGN.md](INTERFACE-DESIGN.md).

### 4. DE-specific deepening patterns

Common shallow→deep refactors for bank DE codebases:

**Fat DAG → thin DAG + deep operator**
Before: DAG file contains SQL strings, business logic, and connection strings.
After: DAG file contains only scheduling, dependencies, and operator calls. All logic moves into a testable operator class or Python callable with a clean interface.

**Monolithic dbt model → modular staging + marts**
Before: One large dbt model joins 6 source tables and applies 4 business rules.
After: Staging models expose clean, typed intermediate tables. Mart models apply business rules against the clean staging contract. Each layer is independently testable.

**Coupled Spark job → ingestion seam + transform seam**
Before: A single PySpark script reads S3, transforms, writes back — no testable boundary.
After: `read_partition(date) → DataFrame` is the ingestion seam. `transform(df) → DataFrame` is the transform seam. Both are testable in isolation with small DataFrames.

**Implicit schema → explicit contract**
Before: Two pipeline stages share a table but the schema is undocumented. A source change breaks downstream silently.
After: A Pydantic model or dbt source YAML defines the contract. Tests assert the contract is met on every run.

**Great Expectations sprawl → quality module**
Before: Data quality checks are scattered across DAG tasks, dbt tests, and ad-hoc scripts.
After: A single quality module exposes `validate(dataset, suite) → ValidationResult`. Callers don't know whether it's GX or dbt tests underneath.
