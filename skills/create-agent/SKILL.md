---
name: create-agent
description: Create a full Claude Code agent for use as a main-thread agent (claude --agent). Includes settings.json generation and subagent spawn control. Use when the user asks to create a main agent or custom agent configuration.
---

# Create Agent

Create a Claude Code agent designed to run as the main thread (via `claude --agent <name>` or plugin `settings.json`). This differs from subagents in that it can control which subagents it spawns and can be set as the default agent for a plugin. Follow these steps in order.

## Step 1: Get Name & Description

Ask the user for:
- **Agent name** (kebab-case, e.g. `security-reviewer`) — if already provided, use it directly
- **Description** of the agent's role and specialization

## Step 2: Choose Scope

Use `ask_user` with choices:
- "Project (.claude/agents/) (Recommended)"
- "Personal (~/.claude/agents/)"
- "Plugin (current directory agents/)"

## Step 3: Choose Model

Use `ask_user` with choices:
- "inherit — same model as configured (Recommended)"
- "sonnet — balanced speed and quality"
- "opus — maximum capability"
- "haiku — fast, low-latency"

## Step 4: Configure Tools & Spawn Control

Ask: "What tools should this agent have access to?"
- "All tools (Recommended)"
- "Let me specify a custom tool list"

Ask: "Should this agent control which subagents it can spawn?"
- "No — can spawn any subagent (default)"
- "Yes — let me specify allowed subagent types"

If yes, ask for subagent names. These will be added as `Agent(type1, type2)` in the tools list.

## Step 5: Permission Mode

Use `ask_user` with choices:
- "default — standard permission checking (Recommended)"
- "acceptEdits — auto-accept file edits"
- "plan — read-only exploration mode"
- "dontAsk — auto-deny permission prompts"
- "bypassPermissions — skip all permission checks"

## Step 6: Advanced Configuration

Ask one at a time:

1. **Preload skills**: "Preload any skills into this agent?"
   - "No"
   - "Yes — let me list skill names"

2. **MCP Servers**: "Configure MCP servers for this agent?"
   - "No"
   - "Yes — let me specify server names"
   If yes, ask for server names (must be already configured or provide inline definition).

3. **Memory**: "Enable persistent memory?"
   - "No (default)"
   - "user — remembers across all projects"
   - "project — project-specific, version-controlled"
   - "local — project-specific, not version-controlled"

4. **Max turns**: "Limit agentic turns?"
   - "No limit (default)"
   - "Yes — let me specify"

5. **Hooks**: "Add lifecycle hooks?"
   - "No"
   - "Yes — I'll describe what I need"
   If yes, ask for hook descriptions and generate appropriate hook config.

## Step 7: Write System Prompt

Ask the user: "Describe what this agent should do. I'll write the system prompt."

Craft a comprehensive system prompt that:
- Defines the agent's role and expertise
- Lists its primary responsibilities
- Describes its workflow and decision-making process
- Specifies output format expectations
- References preloaded skills if any were specified

## Step 8: Generate the Agent

Use the template in [templates/agent-template.md](templates/agent-template.md) to generate:

1. **Agent file**: `<scope-path>/<name>.md` with YAML frontmatter + system prompt
2. **Settings file** (optional): If the user wants this as a default agent

Only include frontmatter fields that differ from defaults. `name` and `description` are always required.

## Step 9: Activate as Default (Optional)

Ask: "Set this agent as the default for a plugin?"
- "No"
- "Yes — generate settings.json"

If yes, generate a `settings.json` at the plugin root using [templates/settings-template.md](templates/settings-template.md):
```json
{
  "agent": "<agent-name>"
}
```

## Step 10: Summary

Print:
```
✅ Agent "<name>" created at <path>/<name>.md
Model: <model>
Tools: <tools or "all">
Spawn control: <subagent types or "unrestricted">
```

If settings.json was generated:
```
Default agent: settings.json updated
Run with: claude --agent <name>
```

## Additional Resources

- For frontmatter field reference, see [reference.md](reference.md)
- For generation templates, see [templates/agent-template.md](templates/agent-template.md)
- For settings.json template, see [templates/settings-template.md](templates/settings-template.md)
