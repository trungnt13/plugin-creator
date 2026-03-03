# create-plugin

A Claude Code plugin that scaffolds new skills, subagents, agents, and plugins from existing repository configurations. Supports `.claude/`, `~/.claude/`, and `.github/` (GitHub Copilot CLI) source formats.

## Installation

```bash
/plugin install trungnt13/create-plugin
```

Or test locally:

```bash
claude --plugin-dir /path/to/create-plugin
```

## Skills

### `/create-plugin:create-skill` — Create a Skill

Interactively scaffolds a new Claude Code skill with:
- Proper YAML frontmatter (`name`, `description`, `allowed-tools`, `context`, `agent`, `hooks`, etc.)
- Correct scope placement (project, personal, or plugin)
- Skill type selection (task vs reference)
- Optional supporting files (`reference.md`, `scripts/`, `templates/`)

```
create a new skill called "code-review"
```

### `/create-plugin:create-subagent` — Create a Subagent

Interactively scaffolds a new subagent definition with:
- Model selection (`sonnet`, `opus`, `haiku`, `inherit`)
- Tool restrictions and permission modes
- Optional memory, hooks, background execution, and worktree isolation
- Auto-generated system prompt based on user description

```
create a subagent for reviewing pull requests
```

### `/create-plugin:create-agent` — Create an Agent

Scaffolds a main-thread agent (for use with `claude --agent`) with:
- Subagent spawn control (`Agent(type1, type2)`)
- `settings.json` generation for plugin default agent
- MCP server configuration
- Skills preloading and hooks

```
create an agent that coordinates code review and testing
```

### `/create-plugin:create-plugin` — Create a Plugin

Scans your repo for existing configurations and bundles them into a plugin:
1. **Scans** `.claude/`, `~/.claude/`, and `.github/` for agents, skills, instructions, commands, hooks, MCP configs, and LSP configs
2. **Prompts** you to select which items to include (per category)
3. **Generates** a properly structured Claude Code plugin ready to install

```
scaffold a plugin called "my-tools"
```

## Claude Code Concepts Reference

### Skills

> Source: [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)

Skills extend what Claude can do. A skill is a `SKILL.md` file with optional YAML frontmatter stored in a named directory. Claude uses skills when relevant, or you invoke one directly with `/skill-name`.

**File format**: `<scope>/skills/<skill-name>/SKILL.md`

**Key frontmatter fields**:
| Field | Description |
|-------|-------------|
| `name` | Display name (kebab-case, max 64 chars) |
| `description` | What the skill does — Claude uses this for auto-invocation |
| `allowed-tools` | Tools Claude can use without asking permission |
| `context` | Set to `fork` to run in a subagent |
| `agent` | Subagent type when `context: fork` (`Explore`, `Plan`, `general-purpose`, or custom) |
| `disable-model-invocation` | `true` = only user can invoke |
| `user-invocable` | `false` = only Claude can invoke |
| `argument-hint` | Hint shown in autocomplete (e.g. `[issue-number]`) |

**Scopes** (priority order): Enterprise > Personal (`~/.claude/skills/`) > Project (`.claude/skills/`) > Plugin

**String substitutions**: `$ARGUMENTS`, `$ARGUMENTS[N]`, `$N`, `${CLAUDE_SESSION_ID}`

**Dynamic context**: `` !`command` `` runs shell commands before sending to Claude.

### Subagents & Agents

> Source: [Claude Code Subagents Documentation](https://code.claude.com/docs/en/sub-agents)

Subagents are specialized AI assistants that run in their own context window with custom system prompts, tool access, and permissions. Claude delegates tasks to subagents based on their `description` field.

**File format**: `<scope>/agents/<agent-name>.md`

**Key frontmatter fields**:
| Field | Description |
|-------|-------------|
| `name` | Unique identifier (required) |
| `description` | When Claude should delegate (required) |
| `tools` | Tool allowlist; use `Agent(type)` for spawn control |
| `disallowedTools` | Tool denylist |
| `model` | `sonnet`, `opus`, `haiku`, or `inherit` |
| `permissionMode` | `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan` |
| `maxTurns` | Max agentic turns |
| `skills` | Skills to preload into context |
| `memory` | Persistent memory: `user`, `project`, or `local` |
| `background` | `true` for background execution |
| `isolation` | `worktree` for git worktree isolation |

**Built-in subagents**: `Explore` (haiku, read-only), `Plan` (read-only research), `general-purpose` (all tools)

**Scopes** (priority order): CLI flag > Project (`.claude/agents/`) > Personal (`~/.claude/agents/`) > Plugin

### Plugins

> Source: [Claude Code Plugins Documentation](https://code.claude.com/docs/en/plugins)

Plugins bundle skills, agents, hooks, MCP servers, and LSP servers for distribution and reuse. Skills are namespaced as `/plugin-name:skill-name`.

**Required**: `.claude-plugin/plugin.json` manifest with `name`, `version`, `description`

**Plugin structure**:
```
my-plugin/
├── .claude-plugin/plugin.json    # Manifest (required)
├── README.md
├── agents/                       # Agent definitions
├── skills/                       # Skill directories with SKILL.md
├── commands/                     # Slash command templates
├── hooks/hooks.json              # Event handlers
├── .mcp.json                     # MCP server configs
├── .lsp.json                     # LSP server configs
└── settings.json                 # Default settings (e.g. default agent)
```

**Install**: `/plugin install <repo-or-path>` or `claude --plugin-dir <path>`

## Supported Source Formats

| Source | Path | What's scanned |
|--------|------|----------------|
| Claude Code | `.claude/agents/*.md` | Agent definitions |
| Claude Code | `.claude/skills/*/SKILL.md` | Skill definitions |
| Claude Code | `.claude/instructions.md` | Project instructions |
| Claude Code | `.claude/instructions/*.md` | Modular instructions |
| Claude Code | `.claude/commands/*.md` | Slash commands |
| Claude Code | `.claude/settings.json` | Settings & hooks |
| Claude Code | `.mcp.json` | MCP server configs |
| Claude Code | `.lsp.json` | LSP server configs |
| Personal | `~/.claude/agents/*.md` | Personal agents |
| Personal | `~/.claude/skills/*/SKILL.md` | Personal skills |
| GitHub Copilot | `.github/agents/*.md` | Agent definitions |
| GitHub Copilot | `.github/skills/*.md` | Skill definitions |
| GitHub Copilot | `.github/copilot-instructions.md` | Project instructions |
| GitHub Copilot | `.github/instructions/*.md` | Modular instructions |

## License

MIT
