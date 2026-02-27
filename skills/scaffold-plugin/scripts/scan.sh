#!/usr/bin/env bash
# Scan .claude/ and .github/ directories for agents, skills, instructions, and commands.
# Usage: bash scan.sh [repo_root]

REPO_ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"

echo "=== AGENTS ==="
find "$REPO_ROOT/.claude/agents" -name "*.md" -type f 2>/dev/null | sort
find "$REPO_ROOT/.github/agents" -name "*.md" -type f 2>/dev/null | sort

echo "=== SKILLS ==="
find "$REPO_ROOT/.claude/skills" -name "*.md" -type f 2>/dev/null | sort
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
