# ai-config

Single source of truth for AI coding assistant skills, rules, and commands.
Symlinked to **OpenCode** and **Claude Code** so every tool reads from one place.

## Structure

```
ai-config/
  skills/           # 61 skill directories (SKILL.md each)
  rules/            # 14 rule files
    common/         #   9 general rules (coding style, security, git, etc.)
    python/         #   5 Python-specific rules
  commands/         # 9 speckit slash commands
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

| Tool       | What gets linked                    | Target path                      |
|------------|-------------------------------------|----------------------------------|
| OpenCode   | `skills/`                           | `~/.config/opencode/skills`      |
| Claude Code| `skills/`, `rules/`, `commands/`    | `~/.claude/{skills,rules,commands}` |

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

**Add a command** -- place a `.md` file in `commands/`. It becomes a `/slash-command` in Claude Code.

## Inventory

| Category | Count | Details |
|----------|-------|---------|
| Skills   | 61    | 2 custom + 23 curated (ECC) + 36 gstack |
| Rules    | 14    | 9 common + 5 Python |
| Commands | 9     | Speckit pipeline |

See [docs/SKILLS.md](docs/SKILLS.md) for the full catalog with descriptions.

## Skill Sources

- **Custom** -- hand-written skills specific to this workflow (data-engineer, specify-flow)
- **ECC** -- curated subset from [everything-claude-code](https://github.com/affaan-m/everything-claude-code), filtered to data engineering, DevOps, Python, Go, databases, and security
- **gstack** -- workflow automation skills from [gstack](https://github.com/gstackio/gstack) (QA, shipping, reviews, browser testing, safety)
