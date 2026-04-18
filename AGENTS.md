# AGENTS.md

> Single source of truth for AI coding assistant skills and rules.
> Symlinked to **OpenCode** and **Claude Code** so every tool reads from one place.

This file covers two modes:
- **Using the skills** -- you're in a project that has these skills installed
- **Maintaining this repo** -- you're editing skills, rules, or scripts in `ai-config` itself

---

## Architecture

```
ai-config/
  skills/           # 19 invocable skill directories (each has SKILL.md)
  rules/            # 15 always-on rule files
    common/         #  10 language-agnostic rules
    python/         #   5 Python-scoped rules (frontmatter: paths: ["**/*.py"])
  scripts/          # install.sh
  docs/             # Full skill catalog (SKILLS.md)
```

**Two-tier system:**
- **Rules** (`rules/`) -- always loaded, always active. Guidelines for coding style, security, git, testing, performance.
- **Skills** (`skills/`) -- invoked on demand via slash commands or proactive triggers. Each skill has specialized workflows.

**Skill sources:**

| Source | Count | Role |
|--------|-------|------|
| ECC | 17 | Supporting reference (coding standards, testing, infra). |
| Custom | 2 | Local skills (`data-engineer`, `karpathy-guidelines`). |

**Symlink topology:**

| Tool | Linked | Target |
|------|--------|--------|
| OpenCode | `skills/` | `~/.config/opencode/skills` |
| Claude Code | `skills/`, `rules/` | `~/.claude/skills`, `~/.claude/rules` |

---

## Using the Skills

### Development Workflow

Supported development patterns with ECC skills and custom guidance:

| Pattern | Skills |
|---------|--------|
| Research before coding | `search-first` (ECC) |
| Code quality | `karpathy-guidelines` (auto-loads on code work) |
| Testing | `tdd-workflow`, `python-testing`, `golang-testing` |
| Security review | `security-review`, `security-scan` |
| Data engineering | `data-engineer`, `database-migrations`, `postgres-patterns`, `clickhouse-io` |
| Infrastructure | `deployment-patterns`, `docker-patterns` |

### Claude Code Auto-Loading

`karpathy-guidelines` auto-loads for code-writing, refactoring, debugging, and code-review tasks via the `rules/common/karpathy-guidelines.md` rule. See [docs/SKILLS.md](docs/SKILLS.md) for the full catalog.

### Voice and Tone

Direct, concrete, sharp. Name the file, the function, the command.
- No em dashes (use commas, periods, "...")
- No AI vocabulary (delve, crucial, robust, comprehensive, nuanced)
- Short paragraphs. End with what to do.

### Completion Status

Every task ends with one of four statuses:
- `DONE` -- task complete, all checks pass
- `DONE_WITH_CONCERNS` -- complete but with noted issues
- `BLOCKED` -- cannot proceed, state why
- `NEEDS_CONTEXT` -- missing information to continue

---

## Maintaining This Repo

### Adding a Skill

1. Create `skills/<name>/SKILL.md` with YAML frontmatter:

```yaml
---
name: my-skill
description: When and how to use this skill. One paragraph.
---
```

2. Write the skill body below the frontmatter.
3. Both OpenCode and Claude Code auto-discover it via the symlink. No registration step.

For ECC-sourced skills, add `origin: ECC` to frontmatter.
For Claude Code auto-triggering, add a matching rule in `rules/common/` or `rules/python/`.

### Adding a Rule

Place a `.md` file in the appropriate directory:

- `rules/common/` -- applies to all languages, all projects
- `rules/python/` -- Python-specific. Must include path-scoping frontmatter:

```yaml
---
paths:
  - "**/*.py"
  - "**/*.pyi"
---
```

Python rules should extend the common rule: add `> This file extends [common/<name>.md]` at the top.

Claude Code loads rules automatically. OpenCode does not consume rules (only skills).

### Syncing gstack Skills

gstack skills are auto-generated upstream. After running `gstack-upgrade`:

```bash
./scripts/sync-gstack.sh
```

This pulls updated SKILL.md files from `~/Works/gstack/.opencode/skills/`.

**Do NOT edit files marked `<!-- AUTO-GENERATED from SKILL.md.tmpl -->`.**
Edit the upstream template in the gstack repo instead.

### Install / Uninstall

```bash
# Create symlinks to all supported tools
./scripts/install.sh

# Preview without changes
./scripts/install.sh --dry-run

# Remove all symlinks
./scripts/install.sh --uninstall
```

Idempotent. Re-running checks existing links and reports status.

### Removing a Skill

Delete the directory from `skills/`. Gone from all tools immediately.

### Git Conventions

- **Branch:** `main` only
- **Commits:** conventional format: `<type>: <description>`
- **Types:** `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `ci`
- **Do NOT commit:** gstack binaries (gitignored), `.DS_Store`, `.env` files

### What NOT to Do

- Do not edit auto-generated `SKILL.md` files (marked with `AUTO-GENERATED` comment)
- Do not commit files in `skills/gstack/bin/` (binaries, ~59MB each, gitignored)
- Do not add tool-specific config that breaks the single-source-of-truth model
- Do not create skills without YAML frontmatter (tools won't discover them)

---

## File Reference

| Path | Purpose |
|------|---------|
| `AGENTS.md` | This file. Repo-level onboarding for AI agents. |
| `README.md` | Human-readable project overview. |
| `rules/common/agents.md` | Runtime skill routing table (loaded as a rule). |
| `rules/common/karpathy-guidelines.md` | Always-on Claude Code rule that auto-loads `karpathy-guidelines` for coding work. |
| `rules/common/development-workflow.md` | gstack lifecycle phases. |
| `rules/common/git-workflow.md` | Commit format and PR workflow. |
| `rules/common/coding-style.md` | Code formatting and style rules. |
| `rules/common/security.md` | Security rules (always-on). |
| `rules/common/testing.md` | Testing requirements (always-on). |
| `rules/python/*.md` | Python-specific extensions of common rules. |
| `docs/SKILLS.md` | Full catalog of all 61 skills with triggers. |
| `scripts/install.sh` | Symlink installer (supports `--dry-run`, `--uninstall`). |
| `scripts/sync-gstack.sh` | Pulls latest gstack skills from upstream. |
| `skills/gstack/ETHOS.md` | gstack philosophy: Boil the Lake, Search Before Building, User Sovereignty. |
