#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
GSTACK_DIR="$HOME/Works/gstack"
GSTACK_SKILLS="$GSTACK_DIR/.opencode/skills"

# --- Preflight ---
if [ ! -d "$GSTACK_SKILLS" ]; then
  echo "Error: gstack skills not found at $GSTACK_SKILLS"
  echo "Make sure ~/Works/gstack/ exists and has been built."
  exit 1
fi

echo "=== Sync gstack skills ==="
echo "  From: $GSTACK_SKILLS"
echo "  To:   $REPO_DIR/skills/"
echo ""

added=0
updated=0
unchanged=0

# Sync the root gstack/ SKILL.md
cp "$GSTACK_SKILLS/gstack/SKILL.md" "$REPO_DIR/skills/gstack/SKILL.md"

# Sync gstack runtime files (bin, browse, review, ETHOS.md)
cp -RL "$GSTACK_DIR/bin" "$REPO_DIR/skills/gstack/bin"
mkdir -p "$REPO_DIR/skills/gstack/browse/bin" "$REPO_DIR/skills/gstack/browse/dist"
cp -RL "$GSTACK_DIR/browse/bin"/* "$REPO_DIR/skills/gstack/browse/bin/" 2>/dev/null || true
cp -RL "$GSTACK_DIR/browse/dist"/* "$REPO_DIR/skills/gstack/browse/dist/" 2>/dev/null || true
cp "$GSTACK_DIR/ETHOS.md" "$REPO_DIR/skills/gstack/ETHOS.md"
cp "$GSTACK_DIR/review/checklist.md" "$REPO_DIR/skills/gstack/review/checklist.md" 2>/dev/null || true

# Sync each gstack-* skill
for src_dir in "$GSTACK_SKILLS"/gstack-*/; do
  [ -d "$src_dir" ] || continue
  name=$(basename "$src_dir")
  dest_dir="$REPO_DIR/skills/$name"

  if [ ! -d "$dest_dir" ]; then
    cp -R "$src_dir" "$dest_dir"
    echo "  [new] $name"
    ((added++))
  elif ! diff -q "$src_dir/SKILL.md" "$dest_dir/SKILL.md" > /dev/null 2>&1; then
    cp -R "$src_dir"/* "$dest_dir/"
    echo "  [upd] $name"
    ((updated++))
  else
    ((unchanged++))
  fi
done

# Copy gstack-upgrade into nested location too
cp "$REPO_DIR/skills/gstack-upgrade/SKILL.md" "$REPO_DIR/skills/gstack/gstack-upgrade/SKILL.md"

echo ""
echo "Results: $added added, $updated updated, $unchanged unchanged"

if [ $((added + updated)) -gt 0 ]; then
  echo ""
  echo "Changes detected. Review and commit:"
  echo "  cd $REPO_DIR && git diff --stat && git add -A && git commit -m 'sync gstack skills'"
fi
