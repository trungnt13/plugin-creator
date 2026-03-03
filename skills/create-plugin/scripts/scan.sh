#!/usr/bin/env bash
# Scan .claude/, ~/.claude/, and .github/ directories for all plugin-eligible components.
# Usage: bash scan.sh [repo_root]

REPO_ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
USER_CLAUDE="$HOME/.claude"

echo "=== AGENTS ==="
find "$REPO_ROOT/.claude/agents" -name "*.md" -type f 2>/dev/null | sort
find "$USER_CLAUDE/agents" -name "*.md" -type f 2>/dev/null | sort
find "$REPO_ROOT/.github/agents" -name "*.md" -type f 2>/dev/null | sort

echo "=== SKILLS ==="
find "$REPO_ROOT/.claude/skills" -name "SKILL.md" -type f 2>/dev/null | sort
find "$REPO_ROOT/.claude/skills" -name "*.md" ! -name "SKILL.md" -type f 2>/dev/null | sort
find "$USER_CLAUDE/skills" -name "SKILL.md" -type f 2>/dev/null | sort
find "$REPO_ROOT/.github/skills" -name "*.md" -type f 2>/dev/null | sort

echo "=== INSTRUCTIONS ==="
[ -f "$REPO_ROOT/.claude/instructions.md" ] && echo "$REPO_ROOT/.claude/instructions.md"
find "$REPO_ROOT/.claude/instructions" -name "*.md" -type f 2>/dev/null | sort
[ -f "$REPO_ROOT/.claude/settings.json" ] && echo "$REPO_ROOT/.claude/settings.json"
[ -f "$REPO_ROOT/.claude/settings.local.json" ] && echo "$REPO_ROOT/.claude/settings.local.json"
[ -f "$REPO_ROOT/.github/copilot-instructions.md" ] && echo "$REPO_ROOT/.github/copilot-instructions.md"
find "$REPO_ROOT/.github/instructions" -name "*.md" -type f 2>/dev/null | sort

echo "=== COMMANDS ==="
find "$REPO_ROOT/.claude/commands" -name "*.md" -type f 2>/dev/null | sort

echo "=== HOOKS ==="
# Extract hooks from settings files
if [ -f "$REPO_ROOT/.claude/settings.json" ]; then
  if command -v python3 &>/dev/null; then
    python3 -c "
import json, sys
try:
    with open('$REPO_ROOT/.claude/settings.json') as f:
        s = json.load(f)
    if 'hooks' in s:
        print('$REPO_ROOT/.claude/settings.json [hooks]')
except: pass
" 2>/dev/null
  elif grep -q '"hooks"' "$REPO_ROOT/.claude/settings.json" 2>/dev/null; then
    echo "$REPO_ROOT/.claude/settings.json [hooks]"
  fi
fi
if [ -f "$REPO_ROOT/.claude/settings.local.json" ]; then
  if command -v python3 &>/dev/null; then
    python3 -c "
import json, sys
try:
    with open('$REPO_ROOT/.claude/settings.local.json') as f:
        s = json.load(f)
    if 'hooks' in s:
        print('$REPO_ROOT/.claude/settings.local.json [hooks]')
except: pass
" 2>/dev/null
  elif grep -q '"hooks"' "$REPO_ROOT/.claude/settings.local.json" 2>/dev/null; then
    echo "$REPO_ROOT/.claude/settings.local.json [hooks]"
  fi
fi

echo "=== MCP ==="
[ -f "$REPO_ROOT/.mcp.json" ] && echo "$REPO_ROOT/.mcp.json"
[ -f "$REPO_ROOT/.claude/.mcp.json" ] && echo "$REPO_ROOT/.claude/.mcp.json"

echo "=== LSP ==="
[ -f "$REPO_ROOT/.lsp.json" ] && echo "$REPO_ROOT/.lsp.json"
