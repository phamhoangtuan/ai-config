# Skill Catalog

60 skills organized by role. gstack provides the primary workflow. ECC skills are
supporting reference material invoked during gstack workflows.

---

## Primary Workflow: gstack (36 skills)

gstack is the default framework for all development interaction. Its philosophy:
**Boil the Lake** (do the complete thing), **Search Before Building**, **User Sovereignty**.

### Planning & Review

| Skill | Trigger | Description |
|-------|---------|-------------|
| `gstack-autoplan` | "auto review" | Run CEO + design + eng + DX reviews sequentially |
| `gstack-plan-ceo-review` | "think bigger" | CEO-level scope and ambition review |
| `gstack-plan-eng-review` | "engineering review" | Lock architecture, data flow, edge cases, tests |
| `gstack-plan-design-review` | "design critique" | Rate each design dimension 0-10 |
| `gstack-plan-devex-review` | "DX review" | Developer experience plan review |
| `gstack-office-hours` | "brainstorm" | Product idea validation (startup or builder mode) |
| `gstack-review` | "code review" | Pre-landing PR review for structural issues |
| `gstack-retro` | "weekly retro" | Engineering retrospective with shipping streaks |

### QA & Testing

| Skill | Trigger | Description |
|-------|---------|-------------|
| `gstack-qa` | "QA" | Browser-based QA: find bugs, fix, re-verify |
| `gstack-qa-only` | "just report bugs" | QA report only, no code changes |
| `gstack-benchmark` | "performance" | Page load, Core Web Vitals, bundle size tracking |
| `gstack-health` | "health check" | Code quality dashboard (type checker, linter, tests) |

### Shipping & Deploy

| Skill | Trigger | Description |
|-------|---------|-------------|
| `gstack-ship` | "ship" | Run tests, review diff, push, create PR |
| `gstack-land-and-deploy` | "land" | Merge PR, wait for CI, verify production health |
| `gstack-setup-deploy` | "setup deploy" | Configure deploy platform settings |
| `gstack-canary` | "monitor deploy" | Post-deploy canary monitoring |
| `gstack-document-release` | "update docs" | Sync docs to match what shipped |

### Browser & Interaction

| Skill | Trigger | Description |
|-------|---------|-------------|
| `gstack` | -- | Root skill: headless browser for testing and dogfooding |
| `gstack-browse` | "open in browser" | Navigate, interact, screenshot, verify (~100ms/cmd) |
| `gstack-open-gstack-browser` | "launch browser" | AI-controlled visible Chromium window |
| `gstack-setup-browser-cookies` | "import cookies" | Import cookies from real browser for auth |
| `gstack-pair-agent` | "pair agent" | Share browser session with remote AI agent |

### Design

| Skill | Trigger | Description |
|-------|---------|-------------|
| `gstack-design-consultation` | "design system" | Build complete design system from scratch |
| `gstack-design-html` | "build me a page" | Generate production HTML/CSS from designs |
| `gstack-design-review` | "visual QA" | Find and fix visual inconsistencies |
| `gstack-design-shotgun` | "show me options" | Generate multiple design variants for comparison |
| `gstack-devex-review` | "test the DX" | Live developer experience audit |

### Safety & State

| Skill | Trigger | Description |
|-------|---------|-------------|
| `gstack-careful` | "be careful" | Warn before destructive commands |
| `gstack-freeze` | "freeze" | Restrict edits to one directory |
| `gstack-guard` | "guard mode" | Careful + freeze combined |
| `gstack-unfreeze` | "unfreeze" | Remove directory edit restriction |
| `gstack-checkpoint` | "save progress" | Save/resume working state checkpoints |
| `gstack-investigate` | "debug this" | Systematic root-cause debugging |
| `gstack-learn` | "show learnings" | Manage project learnings across sessions |
| `gstack-cso` | "security audit" | Infrastructure-first security audit (OWASP, STRIDE) |
| `gstack-upgrade` | "upgrade gstack" | Update gstack to latest version |

---

## Supporting Skills: Coding Standards & Patterns (ECC)

Reference material invoked during gstack workflows for language-specific patterns,
architecture guidance, and coding standards.

| Skill | Description |
|-------|-------------|
| `coding-standards` | Universal coding standards for TypeScript, JavaScript, React, Node.js |
| `api-design` | REST API patterns -- resource naming, status codes, pagination, versioning |
| `backend-patterns` | Backend architecture, DB optimization, server-side patterns |
| `python-patterns` | PEP 8, type hints, idiomatic patterns for robust Python applications |
| `golang-patterns` | Idiomatic Go patterns, conventions, best practices |
| `blueprint` | Multi-session engineering project planning with dependency graphs |
| `claude-api` | Anthropic Claude API patterns (Python/TS) -- Messages API, streaming, tool use |
| `cost-aware-llm-pipeline` | LLM cost optimization -- model routing, budget tracking, prompt caching |

## Supporting Skills: Testing & Quality (ECC)

| Skill | Description |
|-------|-------------|
| `tdd-workflow` | Test-driven development with 80%+ coverage enforcement |
| `e2e-testing` | Playwright E2E testing, Page Object Model, CI/CD integration |
| `python-testing` | pytest, TDD, fixtures, mocking, parametrization, coverage |
| `golang-testing` | Table-driven tests, subtests, benchmarks, fuzzing, TDD |
| `verification-loop` | Comprehensive verification system for code sessions |
| `eval-harness` | Eval-driven development framework |
| `plankton-code-quality` | Write-time code quality enforcement via hooks (formatting, linting) |

## Supporting Skills: Data & Databases (ECC)

| Skill | Description |
|-------|-------------|
| `clickhouse-io` | ClickHouse query optimization, analytics, high-performance analytical workloads |
| `database-migrations` | Schema changes, rollbacks, zero-downtime migrations (Postgres, MySQL, ORMs) |
| `postgres-patterns` | PostgreSQL query optimization, schema design, indexing, security |

## Supporting Skills: Infrastructure (ECC)

| Skill | Description |
|-------|-------------|
| `deployment-patterns` | CI/CD pipelines, Docker, health checks, rollback strategies |
| `docker-patterns` | Docker/Compose, container security, networking, multi-service orchestration |

## Supporting Skills: Security (ECC)

| Skill | Description |
|-------|-------------|
| `security-review` | Security checklist for auth, user input, secrets, API endpoints |
| `security-scan` | Scan Claude Code / OpenCode config for vulnerabilities and injection risks |

## Supporting Skills: Workflow (ECC)

| Skill | Description |
|-------|-------------|
| `search-first` | Research-before-coding -- find existing tools/libraries before writing custom code |

---

## Custom Skills (1)

| Skill | Description |
|-------|-------------|
| `data-engineer` | DAMA-DMBOK data engineering best practices -- data quality, metadata, security, architecture |

---

## Rules (14)

### Common (9)

`agents` `coding-style` `development-workflow` `git-workflow` `hooks` `patterns` `performance` `security` `testing`

### Python (5)

`coding-style` `hooks` `patterns` `security` `testing`
