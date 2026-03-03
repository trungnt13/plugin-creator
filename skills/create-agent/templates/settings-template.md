# Settings Template

Generate a `settings.json` to set a default agent for a plugin or project.

## Plugin Default Agent

Place at the plugin root (next to `.claude-plugin/`):

```json
{
  "agent": "<agent-name>"
}
```

This activates the named agent as the main thread when the plugin is enabled. The agent must be defined in the plugin's `agents/` directory.

## What settings.json Does

When an agent is set as default via `settings.json`:
- The agent's system prompt replaces the default Claude Code system prompt
- Tool restrictions from the agent are applied
- Model selection from the agent is used
- The agent's hooks, MCP servers, and skills are loaded

## Priority

Settings from `settings.json` file take priority over `settings` declared in `plugin.json`. Unknown keys are silently ignored. Currently only the `agent` key is supported.

## Example

Given this plugin structure:
```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
├── agents/
│   └── security-reviewer.md
└── settings.json          ← {"agent": "security-reviewer"}
```

When installed, `security-reviewer` becomes the active agent automatically.
