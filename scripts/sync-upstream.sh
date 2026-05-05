#!/usr/bin/env bash
# Sync vendored skills from WordPress/agent-skills.
#
# This refreshes every skill except wp-php-coding-standards (our local addition).
# Run from repo root:
#
#   ./scripts/sync-upstream.sh                   # latest main
#   ./scripts/sync-upstream.sh <commit-or-tag>   # pin to a specific upstream ref
#
# After running, review the diff and commit. The upstream commit SHA is recorded
# in .upstream-version so future syncs can show what changed.

set -euo pipefail

UPSTREAM_REPO="https://github.com/WordPress/agent-skills.git"
LOCAL_SKILL="wp-php-coding-standards"   # our skill — never overwritten
REF="${1:-main}"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN_DIR="$REPO_ROOT/plugins/wp-plugin-skills"
SKILLS_DIR="$PLUGIN_DIR/skills"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "→ Cloning $UPSTREAM_REPO @ $REF"
git clone --depth=1 --branch "$REF" "$UPSTREAM_REPO" "$TMP_DIR/upstream" 2>/dev/null \
    || git clone "$UPSTREAM_REPO" "$TMP_DIR/upstream"

if [ "$REF" != "main" ]; then
    git -C "$TMP_DIR/upstream" checkout "$REF"
fi

UPSTREAM_SHA="$(git -C "$TMP_DIR/upstream" rev-parse HEAD)"
echo "→ Upstream HEAD: $UPSTREAM_SHA"

echo "→ Replacing vendored skills (preserving $LOCAL_SKILL/)"
# Move our local skill aside so we don't lose it.
if [ -d "$SKILLS_DIR/$LOCAL_SKILL" ]; then
    mv "$SKILLS_DIR/$LOCAL_SKILL" "$TMP_DIR/$LOCAL_SKILL.bak"
fi

# Wipe and replace.
rm -rf "$SKILLS_DIR"
mkdir -p "$SKILLS_DIR"
cp -R "$TMP_DIR/upstream/skills/." "$SKILLS_DIR/"

# Restore our local skill.
if [ -d "$TMP_DIR/$LOCAL_SKILL.bak" ]; then
    mv "$TMP_DIR/$LOCAL_SKILL.bak" "$SKILLS_DIR/$LOCAL_SKILL"
fi

# Refresh LICENSE in case upstream updated it.
cp "$TMP_DIR/upstream/LICENSE" "$REPO_ROOT/LICENSE"

# Record the synced commit.
echo "$UPSTREAM_SHA" > "$REPO_ROOT/.upstream-version"

echo "✓ Synced. Review with: git status && git diff plugins/wp-plugin-skills/skills/"
echo "  Pinned to: $UPSTREAM_SHA"
