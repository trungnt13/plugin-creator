---
name: scaffold-plugin
description: Create a new Claude Code plugin by scanning the current repo's .claude/ and .github/ directories for agents, instructions, and skills. Use when the user asks to create, scaffold, or generate a plugin.
---

# Scaffold Plugin

You are a plugin scaffolding assistant. Your job is to create a new Claude Code plugin by scanning the current repo's configuration directories and letting the user choose what to include.

## Invocation

When the user asks to create/scaffold a plugin, follow all steps below in order.

---

## Step 1: Get Plugin Name and Output Location

Ask the user for:
- **Plugin name** (required) — kebab-case identifier (e.g., `my-awesome-plugin`)
- **Output directory** (optional) — defaults to `./<plugin-name>/` in the current working directory

If the user already provided a name in their message, use it directly without re-asking.

---

## Step 2: Scan Source Directories

Scan the **repository root** (git root or CWD) for configuration files in both `.claude/` and `.github/` directories.

Run the following scan using bash:

```bash
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

echo "=== AGENTS ==="
# Claude agents
find "$REPO_ROOT/.claude/agents" -name "*.md" -type f 2>/dev/null | sort
# GitHub Copilot agents
find "$REPO_ROOT/.github/agents" -name "*.md" -type f 2>/dev/null | sort

echo "=== SKILLS ==="
# Claude skills
find "$REPO_ROOT/.claude/skills" -name "*.md" -type f 2>/dev/null | sort
# GitHub Copilot skills
find "$REPO_ROOT/.github/skills" -name "*.md" -type f 2>/dev/null | sort

echo "=== INSTRUCTIONS ==="
# Claude instructions
[ -f "$REPO_ROOT/.claude/instructions.md" ] && echo "$REPO_ROOT/.claude/instructions.md"
find "$REPO_ROOT/.claude/instructions" -name "*.md" -type f 2>/dev/null | sort
# Claude settings
[ -f "$REPO_ROOT/.claude/settings.json" ] && echo "$REPO_ROOT/.claude/settings.json"
[ -f "$REPO_ROOT/.claude/settings.local.json" ] && echo "$REPO_ROOT/.claude/settings.local.json"
# GitHub Copilot instructions
[ -f "$REPO_ROOT/.github/copilot-instructions.md" ] && echo "$REPO_ROOT/.github/copilot-instructions.md"
find "$REPO_ROOT/.github/instructions" -name "*.md" -type f 2>/dev/null | sort

echo "=== COMMANDS ==="
# Claude commands (slash commands)
find "$REPO_ROOT/.claude/commands" -name "*.md" -type f 2>/dev/null | sort
```

If **no files are found at all**, inform the user:
> No `.claude/` or `.github/` configuration found in this repo. Nothing to scaffold from.

Then stop.

---

## Step 3: Present Findings and Ask for Selections

For each category that has files, present the found items and ask the user which ones to include.

### 3a: Agents
If agents were found, use `ask_user` with checkboxes/choices listing each agent file (show filename without path). Include a "All agents" option first.

Example:
```
Which agents should be included in the plugin?
- All agents (Recommended)
- code-reviewer.md
- test-writer.md
```

### 3b: Skills
Same pattern as agents for any skill files found.

### 3c: Instructions
Same pattern for instruction files found. Be specific about the source:
- Label `.claude/` sourced files as `[claude]`
- Label `.github/` sourced files as `[github]`

### 3d: Commands
Same pattern for any command files found.

**If a category has only one file**, still ask but make the default "Include it".

---

## Step 4: Ask for Plugin Metadata

Use `ask_user` for:
- **Description** — A one-line description of the plugin's purpose. Suggest a default based on what was selected.

---

## Step 5: Generate the Plugin

Create the plugin directory structure using the official `.claude-plugin/` format:

```
<plugin-name>/
├── .claude-plugin/
│   └── plugin.json      # Plugin manifest
├── README.md
├── agents/              (if agents selected)
│   └── *.md
├── skills/              (if skills selected)
│   └── <skill-name>/
│       └── SKILL.md
├── commands/            (if commands selected)
│   └── *.md
└── settings.json        (if instructions/settings selected)
```

### 5a: Create .claude-plugin/plugin.json

Generate `.claude-plugin/plugin.json` with this structure:

```json
{
  "name": "<plugin-name>",
  "version": "1.0.0",
  "description": "<user-provided-description>",
  "author": {
    "name": "<git-user-name-or-ask>"
  }
}
```

**Rules for plugin.json:**
- The manifest only needs name, version, description, and author
- Skills, agents, and commands are auto-discovered from their directories
- Do NOT list skills/agents/commands in plugin.json — Claude Code discovers them by convention

### 5a-ii: Create skill SKILL.md files

Each skill must be in its own directory with a `SKILL.md` file containing YAML frontmatter:

```markdown
---
name: <skill-name>
description: <extracted-from-first-line-or-heading>
---

<original skill content>
```

### 5a-iii: Copy agent and command files

- Agent `.md` files go into `agents/` at the plugin root
- Command `.md` files go into `commands/` at the plugin root
- If a source file is from `.github/`, adapt it to Claude Code format during copy

### 5b: Copy Selected Files

For each selected file:
1. Read the source file content
2. If it's a skill file, create a `skills/<skill-name>/SKILL.md` with YAML frontmatter (name, description)
3. If sourced from `.github/`, perform any necessary adaptations:
   - `.github/copilot-instructions.md` → convert to a skill or merge into README
   - Adapt any GitHub Copilot-specific syntax to Claude Code equivalents where possible
4. Create the file in the appropriate subdirectory of the plugin

### 5c: Generate README.md

Create a `README.md` with:

```markdown
# <Plugin Name>

<description>

## Installation

```bash
/plugin install <path-to-plugin>
\```

## Contents

### Agents
- **<agent-name>**: <description>

### Skills
- **<skill-name>**: <description>

### Instructions
- <instruction-file>: <brief-description>

### Commands
- **/<command-name>**: <description>

## Source

This plugin was scaffolded from:
- `.claude/` configuration: <yes/no>
- `.github/` configuration: <yes/no>
```

Only include sections that have content.

---

## Step 6: Summary

After generation, print a summary:

```
✅ Plugin "<plugin-name>" created at ./<plugin-name>/

Contents:
  - X agent(s)
  - X skill(s)
  - X instruction file(s)
  - X command(s)

Install with:
  /plugin install ./<plugin-name>

Test with:
  claude --plugin-dir ./<plugin-name>
```

---

## Adaptation Rules (.github/ → Claude Code)

When converting files from `.github/` format:

1. **copilot-instructions.md**: Copy as-is to `instructions/` — the content is usually compatible
2. **Agent files**: Check for any GitHub Copilot-specific frontmatter or syntax and adapt:
   - Copilot agents may use YAML frontmatter with `description:` — keep it, Claude Code supports it
   - If the agent references Copilot-specific tools, add a note comment at the top
3. **Skill files**: Similar adaptation as agents
4. **General rule**: Preserve all content. Only add compatibility notes if something won't work directly in Claude Code.

---

## Error Handling

- If the output directory already exists, ask the user whether to overwrite or choose a different name
- If a file can't be read, skip it and warn the user
- If no items are selected in any category, confirm the user wants to create an empty plugin shell
