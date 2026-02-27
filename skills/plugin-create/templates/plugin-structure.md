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
- Skills, agents, and commands are auto-discovered from directories
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

## Agent Files

Copy `.md` files directly into `agents/`. Preserve all content including any existing frontmatter.

## Command Files

Copy `.md` files directly into `commands/`. Preserve all content.

## Instructions / Settings

- If `.claude/instructions.md` is selected, copy as `settings.json` or include inline
- If `.claude/settings.json` is selected, merge relevant settings into the plugin's `settings.json`
- `.github/copilot-instructions.md` → copy to a skill or merge into README
