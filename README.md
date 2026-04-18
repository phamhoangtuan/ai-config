# ai-config

Single source of truth for AI coding assistant skills and rules.
Symlinked to **OpenCode** and **Claude Code** so every tool reads from one place.

## Workflow

**gstack is the primary workflow framework.** All development interaction runs through
gstack's lifecycle: Research → Plan → Build → Review → Ship.

**ECC skills are supporting reference material.** They provide coding standards, testing
patterns, security checklists, and language-specific guidance invoked during gstack
workflows.

**Claude Code rules can auto-load supporting guidance for coding work.** This repo uses a
common rule to apply `karpathy-guidelines` automatically for code-writing, refactoring,
debugging, and code-review tasks.

### gstack Lifecycle

| Phase | gstack Skills |
|-------|--------------|
| Research | `search-first` skill (ECC) |
| Plan | `/office-hours`, `/blueprint`, `/plan-eng-review`, `/autoplan` |
| Build | `/investigate` for debugging, `tdd-workflow` skill (ECC) for TDD |
| Review | `/review` (pre-landing), `/cso` (security audit) |
| Ship | `/ship`, `/land-and-deploy`, `/document-release` |

gstack proactively routes to the right skill based on intent. Key triggers:
- Bug or error → `/investigate`
- Ship / deploy / PR → `/ship`
- QA / test the site → `/qa`
- Code review / check diff → `/review`
- New idea / brainstorm → `/office-hours`

## Structure

```
ai-config/
  skills/           # 19 skill directories (SKILL.md each)
  rules/            # 15 rule files
    common/         #  10 general rules (workflow, security, git, etc.)
    python/         #   5 Python-specific rules
  scripts/          # install + maintenance scripts
  docs/             # skill catalog and reference
```

## Quick Start

```bash
# Install: create symlinks to all supported tools
./scripts/install.sh

# Preview without changes
./scripts/install.sh --dry-run

# Remove all symlinks
./scripts/install.sh --uninstall

# After a gstack upgrade, sync updated skills
./scripts/sync-gstack.sh
```

## Supported Tools

| Tool        | What gets linked       | Target path                      |
|-------------|------------------------|----------------------------------|
| OpenCode    | `skills/`              | `~/.config/opencode/skills`      |
| Claude Code | `skills/`, `rules/`    | `~/.claude/{skills,rules}`       |

## Common Tasks

**Add a skill** -- create `skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`).
Both tools auto-discover it.

**Remove a skill** -- delete the directory from `skills/`. Gone from all tools immediately.



**Verify installation** -- run `./scripts/install.sh` again. It checks existing links and
reports status without overwriting valid symlinks.

**Add a rule** -- place a `.md` file in `rules/common/` (all languages) or `rules/python/`
(Python-specific). Claude Code loads rules automatically.

Use a common rule when guidance should auto-apply in Claude Code. OpenCode only consumes
the `skills/` directory, so the same guidance remains available there as a manually
invoked skill.

## Inventory

| Category | Count | Details |
|----------|-------|---------|
| Skills   | 19    | 2 custom + 17 ECC (supporting) |
| Rules    | 15    | 10 common + 5 Python |

See [docs/SKILLS.md](docs/SKILLS.md) for the full catalog with descriptions and triggers.

## Skill Sources

- **ECC** -- supporting reference skills from [everything-claude-code](https://github.com/affaan-m/everything-claude-code). Coding standards, testing patterns, security checklists, infrastructure guides.
- **Custom** -- local skills specific to this workflow (`data-engineer`, `karpathy-guidelines`)
