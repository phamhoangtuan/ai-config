# Skill Catalog

23 skills organized by category. ECC skills are supporting reference material for
coding standards, testing patterns, security checklists, and infrastructure guidance.

---

## Coding Standards & Patterns (ECC)

| Skill | Description |
|-------|-------------|
| `coding-standards` | Universal coding standards for TypeScript, JavaScript, React, Node.js |
| `python-patterns` | PEP 8, type hints, idiomatic patterns for robust Python applications |
| `golang-patterns` | Idiomatic Go patterns, conventions, best practices |
| `blueprint` | Multi-session engineering project planning with dependency graphs |

## Testing & Quality (ECC)

| Skill | Description |
|-------|-------------|
| `tdd-workflow` | Test-driven development with 80%+ coverage enforcement |
| `python-testing` | pytest, TDD, fixtures, mocking, parametrization, coverage |
| `golang-testing` | Table-driven tests, subtests, benchmarks, fuzzing, TDD |
| `verification-loop` | Comprehensive verification system for code sessions |
| `plankton-code-quality` | Write-time code quality enforcement via hooks (formatting, linting) |

## Data & Databases (ECC)

| Skill | Description |
|-------|-------------|
| `clickhouse-io` | ClickHouse query optimization, analytics, high-performance analytical workloads |
| `database-migrations` | Schema changes, rollbacks, zero-downtime migrations (Postgres, MySQL, ORMs) |
| `postgres-patterns` | PostgreSQL query optimization, schema design, indexing, security |

## Infrastructure (ECC)

| Skill | Description |
|-------|-------------|
| `deployment-patterns` | CI/CD pipelines, Docker, health checks, rollback strategies |
| `docker-patterns` | Docker/Compose, container security, networking, multi-service orchestration |

## Security (ECC)

| Skill | Description |
|-------|-------------|
| `security-review` | Security checklist for auth, user input, secrets, API endpoints |
| `security-scan` | Scan Claude Code / OpenCode config for vulnerabilities and injection risks |

## Workflow (ECC)

| Skill | Description |
|-------|-------------|
| `search-first` | Research-before-coding -- find existing tools/libraries before writing custom code |

---

## Custom Skills (2)

| Skill | Description |
|-------|-------------|
| `data-engineer` | DAMA-DMBOK data engineering best practices -- data quality, metadata, security, architecture |
| `karpathy-guidelines` | Behavioral guidelines for coding work -- surface assumptions, keep code simple, make surgical changes, and define verifiable success criteria |

## Custom Data Engineering Workflow Skills (4)

| Skill | Description |
|-------|-------------|
| `warehouse-analysis` | Unified warehouse discovery and analysis workflow: schema scan, SQL analysis, profiling, and freshness checks |
| `lineage-ops` | Unified lineage workflow: upstream/downstream impact analysis, task lineage annotations, and OpenLineage extractor guidance |
| `airflow-data-engineering` | Unified Airflow workflow: DAG authoring, testing, debugging, plugins, HITL, and migration guidance |
| `dbt-analytics-engineering` | Unified dbt workflow: modeling, command execution, docs retrieval, semantic layer, unit tests, troubleshooting, and migrations |

## Consolidation Map (Astronomer Import)

Imported scopes were merged to reduce surface area and overlap:

- `warehouse-analysis` merges: `warehouse-init`, `analyzing-data`, `profiling-tables`, `checking-freshness`
- `lineage-ops` merges: `tracing-upstream-lineage`, `tracing-downstream-lineage`, `annotating-task-lineage`, `creating-openlineage-extractors`
- `airflow-data-engineering` merges: `airflow`, `authoring-dags`, `testing-dags`, `debugging-dags`, `airflow-plugins`, `airflow-hitl`, `migrating-airflow-2-to-3`
- `dbt-analytics-engineering` merges: `using-dbt-for-analytics-engineering`, `running-dbt-commands`, `adding-dbt-unit-test`, `troubleshooting-dbt-job-errors`, `building-dbt-semantic-layer`, `answering-natural-language-questions-with-dbt`, `fetching-dbt-docs`, `configuring-dbt-mcp-server`, `migrating-dbt-core-to-fusion`, `migrating-dbt-project-across-platforms`, `cosmos-dbt-core`, `cosmos-dbt-fusion`

---

## Rules (15)

### Common (10)

`agents` `coding-style` `development-workflow` `git-workflow` `hooks` `karpathy-guidelines` `patterns` `performance` `security` `testing`

### Python (5)

`coding-style` `hooks` `patterns` `security` `testing`
