# Deepening Pipeline Modules

How to deepen a cluster of shallow pipeline modules safely, given their dependencies. Assumes the vocabulary in [LANGUAGE.md](LANGUAGE.md) — **module**, **interface**, **seam**, **adapter**, **contract**.

Adapted from mattpocock/skills for data engineering codebases.

---

## Dependency categories

When assessing a candidate for deepening, classify its dependencies. The category determines how the deepened module is tested.

### 1. In-process / pure computation

Pure transform logic: no I/O, no external state. A Polars/Pandas/PySpark function that takes a DataFrame and returns a DataFrame.

Always deepenable. Merge the modules and test through the new interface with small in-memory DataFrames. No adapter needed. This is the most important category for DE — push as much business logic here as possible.

### 2. Local-substitutable

Dependencies that have lightweight local stand-ins:
- Postgres → DuckDB or SQLite in tests
- S3 → local filesystem or moto mock
- Kafka → in-memory list or embedded broker
- BigQuery → DuckDB with the same SQL dialect subset

Deepenable if the stand-in exists. The deepened module is tested with the stand-in running in the test suite. The seam is internal; no port at the module's external interface.

### 3. Remote but owned (Ports & Adapters)

Your own services across a network boundary: internal APIs, microservices, internal Kafka topics, your own warehouse tables.

Define a **port** (interface) at the seam. The deep module owns the logic; the transport is injected as an **adapter**. Tests use an in-memory adapter. Production uses a Postgres/Kafka/warehouse adapter.

_DE example_: a customer data enrichment step that calls an internal customer API.
- Port: `CustomerRepository` with `get_by_id(id) → Customer`
- Adapter A (production): `HttpCustomerRepository` that calls the internal API
- Adapter B (test): `InMemoryCustomerRepository` seeded with fixtures

### 4. True external (Mock)

Third-party services you don't control: a banking partner's FTP feed, a vendor API, a SWIFT gateway, a market data provider.

The deepened module takes the external dependency as an injected port; tests provide a mock adapter that returns fixtures captured from real calls.

---

## Seam discipline

- **One adapter means a hypothetical seam. Two adapters means a real one.** Don't introduce a port unless at least two adapters are justified (production + test at minimum).
- **Internal seams vs external seams.** A deep pipeline module can have internal seams (private, used by its own unit tests) as well as the external seam at its interface. Don't expose internal seams through the interface just because they're convenient to test.
- **Materialisation is a seam.** Every time you write a table, file, or topic, you're creating a seam. Make that seam explicit: define a contract on it, test against it, and inject the writer as an adapter.

---

## Testing strategy: replace, don't layer

- Old tests on shallow pipeline modules become waste once tests at the deepened module's interface exist — delete them.
- Write new tests at the deepened module's interface. **The interface is the test surface.**
- Tests assert on observable outcomes through the interface (output DataFrame shape, row counts, specific transformed values) — not internal state.
- Tests survive internal refactors — they describe pipeline behavior, not implementation. If a test breaks when you swap Pandas for Polars inside the same interface, it was testing past the interface.

---

## Common DE deepening patterns

### Fat DAG → thin DAG + deep callable

**Before**: Airflow DAG contains inline SQL, connection string construction, and business logic in `PythonOperator` lambdas.

**After**: DAG is thin scheduling only. A `PythonOperator` calls `run_reconciliation(date, config)`. That callable is a deep module: testable with `pytest`, no Airflow dependency, accepts a fake config for tests.

Dependency category: in-process (if the callable accepts injected DB adapter) or local-substitutable (if it uses DuckDB in tests).

### String-interpolated SQL → dbt model + contract

**Before**: Python code builds SQL strings with f-strings, runs them against the warehouse. No schema validation, no contract.

**After**: dbt model defines the transform. `dbt test` enforces the contract (not_null, unique, accepted_values). The interface is the model's output schema, tested on every run.

Dependency category: local-substitutable (dbt + DuckDB for unit tests) or remote owned (dbt + actual warehouse in CI).

### Monolithic Spark job → ingestion seam + transform seam + write seam

**Before**: One PySpark script reads S3, applies 300 lines of business logic, writes back — three concerns tangled together, untestable without a cluster.

**After**:
- `read_partition(date, config) → DataFrame` — ingestion seam. Local-substitutable with local Parquet files.
- `transform(df: DataFrame) → DataFrame` — pure transform. In-process, testable with tiny DataFrames.
- `write_partition(df, date, config) → None` — write seam. Local-substitutable with local filesystem.

### Scattered data quality → quality module

**Before**: Quality checks live in DAG tasks, dbt tests, and ad-hoc SQL assertions scattered across files. Duplicated logic, no single place to update.

**After**: `validate(df: DataFrame, suite: str) → ValidationResult`. Callers don't know whether it runs Great Expectations, dbt tests, or custom assertions. The quality logic is deep behind a small interface. Testing: inject a fake `suite` that returns a controlled `ValidationResult`.
