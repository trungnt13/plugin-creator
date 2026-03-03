---
name: create-subagent
description: Create a new Claude Code subagent definition with proper YAML frontmatter, tool restrictions, and system prompt. Use when the user asks to create, scaffold, or generate a subagent.
---

# Create Subagent

Create a new Claude Code subagent following the official documentation. Follow these steps in order.

## Step 1: Get Name & Description

Ask the user for:
- **Subagent name** (kebab-case, e.g. `code-reviewer`) — if already provided, use it directly
- **Description** of when Claude should delegate to this subagent

The description is critical — Claude uses it to decide when to delegate tasks. Include phrases like "use proactively" if you want Claude to delegate eagerly.

## Step 2: Choose Scope

Use `ask_user` with choices:
- "Project (.claude/agents/) (Recommended)"
- "Personal (~/.claude/agents/)"
- "Plugin (current directory agents/)"

## Step 3: Choose Model

Use `ask_user` with choices:
- "inherit — same model as main conversation (Recommended)"
- "sonnet — balanced speed and quality"
- "haiku — fast, low-latency"
- "opus — maximum capability"

## Step 4: Configure Tools

Use `ask_user` with choices:
- "All tools (inherit from main conversation) (Recommended)"
- "Read-only (Read, Grep, Glob, Bash)"
- "Read + Edit (Read, Grep, Glob, Bash, Edit, Write)"
- "Let me specify a custom tool list"

If custom, ask for comma-separated tool names. See [reference.md](reference.md) for the full list of available tools.

Optionally ask: "Any tools to explicitly deny?"
- "No"
- "Yes — let me specify"

## Step 5: Permission Mode

Use `ask_user` with choices:
- "default — standard permission checking (Recommended)"
- "acceptEdits — auto-accept file edits"
- "plan — read-only exploration mode"
- "dontAsk — auto-deny permission prompts"
- "bypassPermissions — skip all permission checks"

## Step 6: Optional Configuration

Ask one at a time:

1. **Max turns**: "Limit the number of agentic turns?"
   - "No limit (default)"
   - "Yes — let me specify"

2. **Preload skills**: "Preload any skills into the subagent?"
   - "No"
   - "Yes — let me list skill names"

3. **Memory**: "Enable persistent memory?"
   - "No (default)"
   - "user — remembers across all projects"
   - "project — project-specific, version-controlled"
   - "local — project-specific, not version-controlled"

4. **Background**: "Run as background task by default?"
   - "No (default)"
   - "Yes"

5. **Isolation**: "Use git worktree isolation?"
   - "No (default)"
   - "Yes (worktree) — isolated repo copy"

## Step 7: Write System Prompt

Ask the user: "Describe what this subagent should do. I'll write the system prompt."

Use their description to craft a clear, actionable system prompt. Follow these guidelines:
- Start with the subagent's role ("You are a...")
- Include a "When invoked:" section with numbered steps
- Add a checklist or criteria section
- Specify output format expectations

## Step 8: Generate the Subagent

Use the template in [templates/subagent-template.md](templates/subagent-template.md) to generate the file. Key rules:

- Create `<scope-path>/<name>.md` with YAML frontmatter + system prompt body
- Only include frontmatter fields that differ from defaults
- `name` and `description` are always included

## Step 9: Summary

Print:
```
✅ Subagent "<name>" created at <path>/<name>.md
Model: <model>
Tools: <tools or "all">
Claude will delegate to it when: <description>
```

## Additional Resources

- For frontmatter field reference and tool list, see [reference.md](reference.md)
- For generation templates, see [templates/subagent-template.md](templates/subagent-template.md)
