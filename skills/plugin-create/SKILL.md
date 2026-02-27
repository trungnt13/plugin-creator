---
name: plugin-create
description: Create a new Claude Code plugin by scanning the current repo's .claude/ and .github/ directories for agents, instructions, and skills. Use when the user asks to create, scaffold, or generate a plugin.
---

# Scaffold Plugin

Create a Claude Code plugin from existing repo configuration. Follow these steps in order.

## Step 1: Get Plugin Name

Ask the user for a **plugin name** (kebab-case, e.g. `my-plugin`) and optional **output directory** (defaults to `./<name>/`). If already provided in their message, use it directly.

## Step 2: Scan Source Directories

Run [scripts/scan.sh](scripts/scan.sh) to discover agents, skills, instructions, and commands in `.claude/` and `.github/`. If nothing is found, inform the user and stop.

## Step 3: Ask for Selections

For each non-empty category, use `ask_user` with choices listing each file (filename only). Include "All (Recommended)" as the first choice. Label `.github/` files with `[github]`.

Ask one category at a time: agents → skills → instructions → commands.

If a category has only one file, still ask but default to "Include it".

## Step 4: Ask for Plugin Metadata

Use `ask_user` for a one-line **description**. Suggest a default based on what was selected.

## Step 5: Generate the Plugin

Use the template in [templates/plugin-structure.md](templates/plugin-structure.md) to generate the plugin directory. Key rules:

- Manifest goes in `.claude-plugin/plugin.json` (only name, version, description, author — components are auto-discovered)
- Skills go in `skills/<name>/SKILL.md` with YAML frontmatter
- Agents and commands are copied as `.md` files to their directories
- Generate a `README.md` using [templates/readme-template.md](templates/readme-template.md)

For `.github/` source files, see adaptation rules in [reference.md](reference.md).

## Step 6: Summary

Print:
```
✅ Plugin "<name>" created at ./<name>/
Contents: X agent(s), X skill(s), X instruction(s), X command(s)
Install:  /plugin install ./<name>
Test:     claude --plugin-dir ./<name>
```

## Additional Resources

- For the scan script, see [scripts/scan.sh](scripts/scan.sh)
- For plugin structure and generation templates, see [templates/plugin-structure.md](templates/plugin-structure.md)
- For README generation, see [templates/readme-template.md](templates/readme-template.md)
- For adaptation rules and error handling, see [reference.md](reference.md)
