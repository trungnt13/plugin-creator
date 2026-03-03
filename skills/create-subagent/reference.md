# Reference: Subagent Configuration

> Source: [Claude Code Subagents Documentation](https://code.claude.com/docs/en/sub-agents)

## YAML Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier, lowercase letters and hyphens |
| `description` | Yes | When Claude should delegate to this subagent |
| `tools` | No | Tools the subagent can use. Inherits all if omitted |
| `disallowedTools` | No | Tools to deny (removed from inherited/specified list) |
| `model` | No | `sonnet`, `opus`, `haiku`, or `inherit`. Default: `inherit` |
| `permissionMode` | No | `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan` |
| `maxTurns` | No | Max agentic turns before stopping |
| `skills` | No | Skills to preload into context at startup |
| `mcpServers` | No | MCP servers available to this subagent |
| `hooks` | No | Lifecycle hooks scoped to this subagent |
| `memory` | No | Persistent memory: `user`, `project`, or `local` |
| `background` | No | `true` to always run as background task. Default: `false` |
| `isolation` | No | `worktree` for git worktree isolation |

## Available Tools

Common tools that can be specified in the `tools` or `disallowedTools` fields:

| Tool | Description |
|------|-------------|
| `Read` | Read file contents |
| `Write` | Write/create files |
| `Edit` | Edit existing files |
| `Grep` | Search file contents |
| `Glob` | Find files by pattern |
| `Bash` | Run shell commands (can restrict: `Bash(git *)`, `Bash(npm *)`) |
| `Skill` | Invoke skills (can restrict: `Skill(name)`, `Skill(name *)`) |
| `Agent` | Spawn subagents (can restrict: `Agent(type)`) |

## Subagent Scopes (Priority Order)

1. **CLI flag** (`--agents` JSON) — current session only (highest priority)
2. **Project** — `.claude/agents/<name>.md`
3. **Personal** — `~/.claude/agents/<name>.md`
4. **Plugin** — `<plugin>/agents/<name>.md` (lowest priority)

## Built-in Subagents

| Agent | Model | Tools | Purpose |
|-------|-------|-------|---------|
| `Explore` | Haiku | Read-only | Fast codebase search and analysis |
| `Plan` | Inherit | Read-only | Research for plan mode |
| `general-purpose` | Inherit | All | Complex multi-step tasks |
| `Bash` | Inherit | Terminal | Running commands in separate context |

## Permission Modes

| Mode | Behavior |
|------|----------|
| `default` | Standard permission checking with prompts |
| `acceptEdits` | Auto-accept file edits |
| `dontAsk` | Auto-deny permission prompts (allowed tools still work) |
| `bypassPermissions` | Skip all permission checks |
| `plan` | Read-only exploration |

## Memory Scopes

| Scope | Location | Best for |
|-------|----------|----------|
| `user` | `~/.claude/agent-memory/<name>/` | Learnings across all projects |
| `project` | `.claude/agent-memory/<name>/` | Project-specific, shareable via VCS |
| `local` | `.claude/agent-memory-local/<name>/` | Project-specific, not in VCS |

When memory is enabled, the subagent receives instructions to read/write a `MEMORY.md` file in the memory directory. Read, Write, and Edit tools are auto-enabled.

## Hook Events for Subagents

Hooks can be defined in subagent frontmatter or in project `settings.json`:

| Event | Matcher | When |
|-------|---------|------|
| `PreToolUse` | Tool name | Before subagent uses a tool |
| `PostToolUse` | Tool name | After subagent uses a tool |
| `Stop` | (none) | When subagent finishes |
| `SubagentStart` | Agent name | When subagent begins (in settings.json) |
| `SubagentStop` | Agent name | When subagent completes (in settings.json) |
