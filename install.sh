#!/usr/bin/env bash
# repo-storyteller installer
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/manyamkarthik/repo-storyteller/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- claude codex opencode
# Agents: claude codex opencode cursor gemini copilot agents (all = every agent found)
set -euo pipefail

REPO="${REPO_STORYTELLER_REPO:-manyamkarthik/repo-storyteller}"
BRANCH="${REPO_STORYTELLER_BRANCH:-main}"
SKILL="repo-storyteller"

dir_for() {
  case "$1" in
    claude)   echo "$HOME/.claude/skills" ;;
    codex)    echo "$HOME/.codex/skills" ;;
    opencode) echo "$HOME/.config/opencode/skills" ;;
    cursor)   echo "$HOME/.cursor/skills" ;;
    gemini)   echo "$HOME/.gemini/skills" ;;
    copilot)  echo "$HOME/.copilot/skills" ;;
    agents)   echo "$HOME/.agents/skills" ;;
    *) echo ""; return 1 ;;
  esac
}

home_for() {
  case "$1" in
    claude)   echo "$HOME/.claude" ;;
    codex)    echo "$HOME/.codex" ;;
    opencode) echo "$HOME/.config/opencode" ;;
    cursor)   echo "$HOME/.cursor" ;;
    gemini)   echo "$HOME/.gemini" ;;
    copilot)  echo "$HOME/.copilot" ;;
    agents)   echo "$HOME/.agents" ;;
  esac
}

ALL="claude codex opencode cursor gemini copilot agents"
if [ "$#" -eq 0 ]; then
  TARGETS=""
  for a in $ALL; do [ -d "$(home_for "$a")" ] && TARGETS="$TARGETS $a"; done
  if [ -z "$TARGETS" ]; then
    echo "No agent folders found. Installing for Claude Code and the shared ~/.agents folder."
    TARGETS="claude agents"
  fi
else
  TARGETS="$*"
  [ "$TARGETS" = "all" ] && TARGETS="$ALL"
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
echo "⬇️  Downloading $REPO@$BRANCH ..."
curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/heads/$BRANCH" | tar -xz -C "$TMP"
SRC="$(find "$TMP" -type d -path "*/skills/$SKILL" | head -n1)"
[ -f "$SRC/SKILL.md" ] || { echo "❌ Could not find skills/$SKILL in the download."; exit 1; }

for a in $TARGETS; do
  dest="$(dir_for "$a")" || { echo "⚠️  Unknown agent '$a' (use: $ALL)"; continue; }
  mkdir -p "$dest"
  rm -rf "${dest:?}/$SKILL"
  cp -R "$SRC" "$dest/$SKILL"
  echo "✅ $a → $dest/$SKILL"
done

echo
echo "🎉 Done! Restart your agent, then try:  explain this repo like I'm 5"
