---
name: create-plugin
description: Create a new Claude Code plugin by scanning the current repo's .claude/, ~/.claude/, and .github/ directories for agents, skills, instructions, commands, hooks, and MCP configs. Use when the user asks to create, scaffold, or generate a plugin.
---

# Create Plugin

Create a Claude Code plugin from existing repo configuration. Follow these steps in order.

## Step 1: Get Plugin Name

Ask the user for a **plugin name** (kebab-case, e.g. `my-plugin`) and optional **output directory** (defaults to `./<name>/`). If already provided in their message, use it directly.

## Step 2: Scan Source Directories

Run [scripts/scan.sh](scripts/scan.sh) to discover all components in `.claude/`, `~/.claude/`, and `.github/`. The script scans for:
- **Agents**: `.claude/agents/`, `~/.claude/agents/`, `.github/agents/`
- **Skills**: `.claude/skills/` (including nested SKILL.md), `~/.claude/skills/`, `.github/skills/`
- **Instructions**: `.claude/instructions.md`, `.claude/instructions/`, `.github/copilot-instructions.md`, `.github/instructions/`
- **Commands**: `.claude/commands/`
- **Hooks**: `.claude/settings.json` (hooks section), `.claude/settings.local.json`
- **MCP Configs**: `.mcp.json`, `.claude/.mcp.json`
- **LSP Configs**: `.lsp.json`

If nothing is found, inform the user and stop.

## Step 3: Ask for Selections

For each non-empty category, use `ask_user` with choices listing each file (filename only). Include "All (Recommended)" as the first choice. Label `.github/` files with `[github]` and `~/.claude/` files with `[personal]`.

Ask one category at a time: agents → skills → instructions → commands → hooks → MCP → LSP.

If a category has only one file, still ask but default to "Include it".

## Step 4: Ask for Plugin Metadata

Use `ask_user` for a one-line **description**. Suggest a default based on what was selected.

## Step 5: Generate the Plugin

Use the template in [templates/plugin-structure.md](templates/plugin-structure.md) to generate the plugin directory. Key rules:

- Manifest goes in `.claude-plugin/plugin.json` (only name, version, description, author — components are auto-discovered)
- Skills go in `skills/<name>/SKILL.md` with YAML frontmatter
- Agents are copied as `.md` files to `agents/`
- Commands are copied as `.md` files to `commands/`
- Hooks go in `hooks/hooks.json`
- MCP configs go in `.mcp.json` at plugin root
- LSP configs go in `.lsp.json` at plugin root
- Generate a `README.md` using [templates/readme-template.md](templates/readme-template.md)

For `.github/` source files, see adaptation rules in [reference.md](reference.md).

## Step 6: Summary

Print:
```
✅ Plugin "<name>" created at ./<name>/
Contents: X agent(s), X skill(s), X instruction(s), X command(s), X hook(s), X MCP server(s)
Install:  /plugin install ./<name>
Test:     claude --plugin-dir ./<name>
```

## Additional Resources

- For the scan script, see [scripts/scan.sh](scripts/scan.sh)
- For plugin structure and generation templates, see [templates/plugin-structure.md](templates/plugin-structure.md)
- For README generation, see [templates/readme-template.md](templates/readme-template.md)
- For adaptation rules and error handling, see [reference.md](reference.md)
