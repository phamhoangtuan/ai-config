# ai-config

Single source of truth for AI coding assistant skills and rules.
Symlinked to **OpenCode** and **Claude Code** so every tool reads from one place.

## Workflow

**gstack is the primary workflow framework.** All development interaction runs through
gstack's lifecycle: Research → Plan → Build → Review → Ship.

**ECC skills are supporting reference material.** They provide coding standards, testing
patterns, security checklists, and language-specific guidance invoked during gstack
workflows.

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
  skills/           # 60 skill directories (SKILL.md each)
  rules/            # 14 rule files
    common/         #   9 general rules (workflow, security, git, etc.)
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

**Update gstack skills** -- after running `gstack-upgrade`, run `./scripts/sync-gstack.sh`
to pull the latest generated SKILL.md files into this repo.

**Verify installation** -- run `./scripts/install.sh` again. It checks existing links and
reports status without overwriting valid symlinks.

**Add a rule** -- place a `.md` file in `rules/common/` (all languages) or `rules/python/`
(Python-specific). Claude Code loads rules automatically.

## Inventory

| Category | Count | Details |
|----------|-------|---------|
| Skills   | 60    | 1 custom + 23 ECC (supporting) + 36 gstack (primary workflow) |
| Rules    | 14    | 9 common + 5 Python |

See [docs/SKILLS.md](docs/SKILLS.md) for the full catalog with descriptions and triggers.

## Skill Sources

- **gstack** -- primary workflow framework from [gstack](https://github.com/gstackio/gstack). Covers the full development lifecycle: planning, QA, shipping, design, safety, browser testing.
- **ECC** -- supporting reference skills from [everything-claude-code](https://github.com/affaan-m/everything-claude-code). Coding standards, testing patterns, security checklists, infrastructure guides.
- **Custom** -- hand-written skills specific to this workflow (`data-engineer`)
