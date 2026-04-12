#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DRY_RUN=false
UNINSTALL=false

# --- Parse flags ---
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --uninstall) UNINSTALL=true ;;
    --help|-h)
      echo "Usage: install.sh [--dry-run] [--uninstall]"
      echo ""
      echo "  --dry-run     Preview changes without modifying anything"
      echo "  --uninstall   Remove all symlinks created by this script"
      exit 0
      ;;
    *) echo "Unknown flag: $arg"; exit 1 ;;
  esac
done

# --- Helpers ---
info()  { echo "  [ok]  $1"; }
warn()  { echo "  [!!]  $1"; }
skip()  { echo "  [--]  $1 (skipped)"; }
dry()   { echo "  [dry] $1"; }

link_dir() {
  local source="$1" target="$2" label="$3"

  if $UNINSTALL; then
    if [ -L "$target" ]; then
      if $DRY_RUN; then
        dry "Would remove symlink: $target"
      else
        rm "$target"
        info "Removed symlink: $target"
      fi
    else
      skip "$target is not a symlink"
    fi
    return
  fi

  # Already correctly linked
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    info "$label: $target -> $source"
    return
  fi

  # Exists but is not a symlink (or points elsewhere)
  if [ -e "$target" ] || [ -L "$target" ]; then
    if $DRY_RUN; then
      dry "Would replace: $target -> $source"
      return
    fi
    warn "Replacing existing $target"
    rm -rf "$target"
  fi

  if $DRY_RUN; then
    dry "Would link: $target -> $source"
  else
    ln -s "$source" "$target"
    info "$label: $target -> $source"
  fi
}

# --- Preflight ---
echo ""
if $DRY_RUN; then
  echo "=== ai-config install (dry run) ==="
elif $UNINSTALL; then
  echo "=== ai-config uninstall ==="
else
  echo "=== ai-config install ==="
fi
echo "  Source: $REPO_DIR"
echo ""

# --- OpenCode ---
echo "OpenCode (~/.config/opencode/):"
if [ -d "$HOME/.config/opencode" ]; then
  link_dir "$REPO_DIR/skills" "$HOME/.config/opencode/skills" "skills"
else
  skip "~/.config/opencode/ does not exist"
fi
echo ""

# --- Claude Code ---
echo "Claude Code (~/.claude/):"
if [ -d "$HOME/.claude" ]; then
  link_dir "$REPO_DIR/skills"   "$HOME/.claude/skills"   "skills"
  link_dir "$REPO_DIR/rules"    "$HOME/.claude/rules"    "rules"
  link_dir "$REPO_DIR/commands" "$HOME/.claude/commands"  "commands"
else
  skip "~/.claude/ does not exist"
fi
echo ""

# --- Summary ---
skill_count=$(ls -d "$REPO_DIR/skills"/*/ 2>/dev/null | wc -l | tr -d ' ')
rule_count=$(find "$REPO_DIR/rules" -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
cmd_count=$(ls "$REPO_DIR/commands"/*.md 2>/dev/null | wc -l | tr -d ' ')

if ! $UNINSTALL; then
  echo "Inventory: $skill_count skills, $rule_count rules, $cmd_count commands"
fi
echo "Done."
