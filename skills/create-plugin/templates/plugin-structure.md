# Plugin Structure Template

Generated plugins must follow the `.claude-plugin/` format:

```
<plugin-name>/
├── .claude-plugin/
│   └── plugin.json
├── README.md
├── agents/                (if agents selected)
│   └── <agent-name>.md
├── skills/                (if skills selected)
│   └── <skill-name>/
│       └── SKILL.md
├── commands/              (if commands selected)
│   └── <command-name>.md
├── hooks/                 (if hooks selected)
│   └── hooks.json
├── .mcp.json              (if MCP configs selected)
├── .lsp.json              (if LSP configs selected)
└── settings.json          (if instructions/settings selected)
```

## .claude-plugin/plugin.json

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

Rules:
- Only include name, version, description, and author
- Skills, agents, commands, hooks are auto-discovered from directories
- Do NOT list components in plugin.json

## Skill Files

Each skill goes in `skills/<skill-name>/SKILL.md` with YAML frontmatter:

```markdown
---
name: <skill-name>
description: <extracted-from-first-heading-or-first-line>
---

<original skill content>
```

Extract `description` from the first `#` heading or first non-empty line of the source file.

If the source skill has a directory with supporting files (reference.md, scripts/, templates/), copy the entire directory structure.

## Agent Files

Copy `.md` files directly into `agents/`. Preserve all content including any existing frontmatter.

## Command Files

Copy `.md` files directly into `commands/`. Preserve all content.

## Hooks

Extract the `hooks` object from settings files and place in `hooks/hooks.json`:

```json
{
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "SubagentStart": [...],
    "SubagentStop": [...]
  }
}
```

Preserve all hook configurations including matchers, commands, and types.

## MCP Configs

Copy `.mcp.json` to the plugin root. Preserve all server definitions.

## LSP Configs

Copy `.lsp.json` to the plugin root. Preserve all language server definitions.

## Instructions / Settings

- If `.claude/instructions.md` is selected, copy as `settings.json` or include inline
- If `.claude/settings.json` is selected, merge relevant settings into the plugin's `settings.json`
- `.github/copilot-instructions.md` → copy to a skill or merge into README
