# Reference: Agent Configuration (Main Thread)

> Source: [Claude Code Subagents Documentation](https://code.claude.com/docs/en/sub-agents)

## Overview

Agents and subagents share the same file format (`.md` with YAML frontmatter). The key difference is usage:
- **Agent (main thread)**: Runs via `claude --agent <name>` or as a plugin default via `settings.json`
- **Subagent**: Delegated to by Claude during a conversation

When running as the main thread, an agent's markdown body becomes the system prompt, and it can control which subagents it spawns.

## YAML Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier, lowercase letters and hyphens |
| `description` | Yes | Agent's role and when to use it |
| `tools` | No | Tools the agent can use. Include `Agent(type)` for spawn control |
| `disallowedTools` | No | Tools to deny |
| `model` | No | `sonnet`, `opus`, `haiku`, or `inherit`. Default: `inherit` |
| `permissionMode` | No | `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan` |
| `maxTurns` | No | Max agentic turns |
| `skills` | No | Skills to preload into context |
| `mcpServers` | No | MCP servers available to this agent |
| `hooks` | No | Lifecycle hooks |
| `memory` | No | Persistent memory: `user`, `project`, or `local` |

## Subagent Spawn Control

When an agent runs as the main thread with `claude --agent`, it can control which subagents it spawns using `Agent(type)` syntax in the `tools` field:

```yaml
# Only allow spawning worker and researcher subagents
tools: Agent(worker, researcher), Read, Bash, Edit, Write

# Allow spawning any subagent
tools: Agent, Read, Bash, Edit, Write

# If Agent is omitted from tools, the agent cannot spawn subagents
tools: Read, Bash, Edit, Write
```

This restriction only applies to main-thread agents. Subagents cannot spawn other subagents.

## settings.json for Default Agent

A plugin can set an agent as the default using `settings.json` at the plugin root:

```json
{
  "agent": "<agent-name>"
}
```

This activates the agent's system prompt, tool restrictions, and model when the plugin is enabled.

## Running Agents

```bash
# Run a project agent
claude --agent my-agent

# Run with a plugin
claude --plugin-dir ./my-plugin  # Uses default agent from settings.json

# Run a one-off agent via CLI flag
claude --agents '{"my-agent": {"description": "...", "prompt": "...", "tools": [...]}}'
```

## CLI --agents Flag Format

The `--agents` flag accepts JSON with the same frontmatter fields. Use `prompt` for the system prompt:

```json
{
  "agent-name": {
    "description": "When to use this agent",
    "prompt": "System prompt (markdown body equivalent)",
    "tools": ["Read", "Edit", "Bash"],
    "model": "sonnet",
    "permissionMode": "default",
    "skills": ["skill-1", "skill-2"],
    "mcpServers": ["server-name"],
    "hooks": {},
    "maxTurns": 50,
    "memory": "user"
  }
}
```

## MCP Server Configuration

MCP servers can be referenced by name (if already configured) or defined inline:

```yaml
mcpServers:
  - slack
  - name: custom-server
    command: node
    args: ["./server.js"]
    env:
      API_KEY: "${API_KEY}"
```

See [MCP documentation](https://code.claude.com/docs/en/mcp) for full configuration options.
