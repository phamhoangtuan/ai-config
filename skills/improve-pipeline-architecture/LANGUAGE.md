# Language

Shared vocabulary for every suggestion this skill makes. Use these terms exactly — don't substitute "component," "service," "API," or "boundary." Consistent language is the whole point.

Adapted from mattpocock/skills for data engineering codebases.

---

## Core Architecture Terms

**Module**
Anything with an interface and an implementation. Deliberately scale-agnostic — applies equally to a function, a dbt model, a PySpark transform, an Airflow DAG, or an entire ingestion pipeline.
_Avoid_: unit, component, service, step, layer.

**Interface**
Everything a caller must know to use the module correctly. Includes the type signature, but also: schema contracts, partition/window expectations, ordering constraints, error modes, required configuration, and performance characteristics (e.g., "runs in < 10s on 1M rows").
_Avoid_: API, signature (too narrow).

**Implementation**
What's inside a module — its body of code, SQL, or pipeline logic. Distinct from **Adapter**.

**Depth**
Leverage at the interface — the amount of behaviour a caller (or test) can exercise per unit of interface they have to learn. A module is **deep** when a large amount of pipeline behaviour sits behind a small interface. A module is **shallow** when the interface is nearly as complex as the implementation.
_DE example of shallow_: a DAG task that exposes `run(conn_str, query, schema, partition_col, partition_val, target_table)` — the caller must know as much as the implementation.
_DE example of deep_: a transform function that exposes `apply(df: DataFrame) → DataFrame` but hides join logic, null handling, and business rules inside.

**Seam**
A place where you can alter pipeline behaviour without editing at that place. The location at which a module's interface lives. Choosing where to put the seam is its own design decision.
_Avoid_: boundary (overloaded with DDD's bounded context).
_DE examples_: the interface between ingestion and transform, between staging and mart, between a DAG task and its Python callable.

**Adapter**
A concrete thing that satisfies an interface at a seam. Describes role (what slot it fills), not substance (what's inside).
_DE examples_: a Postgres reader adapter, an S3 writer adapter, an in-memory DataFrame adapter for tests.

**Leverage**
What callers get from depth. More pipeline capability per unit of interface they have to learn. One deep transform pays back across N DAG tasks and M tests.

**Locality**
What maintainers get from depth. Change, bugs, knowledge, and verification concentrate at one place rather than spreading across callers. Fix once, fixed everywhere.

---

## DE-Specific Terms

**Contract**
The explicit schema agreement between a producer module and a consumer module. A contract defines: column names, types, nullability, cardinality expectations, and partition/window semantics. The seam between pipeline stages should be a contract.
_Without a contract_: a source schema change breaks downstream silently.
_With a contract_: the contract is tested on every run; failures are caught at the producing stage, not the consuming stage.

**Materialisation**
A concrete output artifact at a seam: a table, a Parquet file, a Kafka topic, an in-memory DataFrame in tests. The seam is where the materialisation lives. Tests use lightweight materialisations (in-memory DataFrames, DuckDB tables); production uses warehouse tables.

**Orchestration layer**
The DAG/workflow definitions (Airflow, Prefect, Dagster). Should be **thin**: scheduling, dependency graph, retry logic, and operator calls only. Business logic does not belong here. A fat orchestration layer is a shallow module — it exposes the implementation.

**Transform layer**
The functions, dbt models, or Spark jobs that apply business logic to data. The deepest modules live here. A deep transform has a small interface (`apply(df) → df`) and hides all the complexity inside. A shallow transform is a SQL string interpolated inside a DAG file.

**Ingestion layer**
Extractors, readers, CDC connectors. Should expose a simple interface: `read(window: DateRange) → DataFrame`. Hides connection details, retry logic, and source-specific quirks behind the seam.

---

## Principles

- **Depth is a property of the interface, not the implementation.** A deep pipeline module can be internally composed of many small functions — they just aren't exposed through the interface.
- **The deletion test.** Imagine deleting the module. If complexity vanishes, the module wasn't hiding anything (it was a pass-through). If complexity reappears across N callers, the module was earning its keep.
- **The interface is the test surface.** Tests and callers cross the same seam. If you want to test *past* the interface (e.g., by directly querying the database after a transform), the module is the wrong shape.
- **One adapter means a hypothetical seam. Two adapters means a real one.** Don't introduce a contract or seam unless at least two adapters are justified (typically production + test).
- **The orchestration layer should be thin.** Business logic in DAG files is a smell — it's testing and refactoring in the hardest possible place.

---

## Rejected framings

- **"Layer" as a fixed tier** (ingestion layer, transform layer, serving layer): layers are too coarse. Any layer can contain deep or shallow modules. Use depth to evaluate, not layer position.
- **"Pipeline" as the unit of architecture**: pipelines are workflows, not modules. The modules are inside the pipeline. Evaluate module depth, not pipeline complexity.
- **"Interface" as just the dbt model name or function signature**: interface here includes schema contracts, partition semantics, and error modes — everything a caller must know.
