---
name: create-skill
description: Create a new Claude Code skill with proper structure, YAML frontmatter, and supporting files. Use when the user asks to create, scaffold, or generate a skill.
---

# Create Skill

Create a new Claude Code skill following the official Agent Skills standard. Follow these steps in order.

## Step 1: Get Skill Name & Description

Ask the user for:
- **Skill name** (kebab-case, e.g. `my-skill`) — if already provided, use it directly
- **One-line description** of what the skill does

## Step 2: Choose Scope

Use `ask_user` with choices:
- "Project (.claude/skills/) (Recommended)"
- "Personal (~/.claude/skills/)"
- "Plugin (current directory skills/)"

## Step 3: Choose Skill Type

Use `ask_user` with choices:
- "Task — step-by-step instructions for a specific action (Recommended)"
- "Reference — knowledge/conventions Claude applies to your work"

## Step 4: Configure Frontmatter Options

Ask one question at a time using `ask_user`:

1. **Invocation**: "Who should invoke this skill?"
   - "Both user and Claude (default)"
   - "User only (disable-model-invocation: true)"
   - "Claude only (user-invocable: false)"

2. **Execution context**: "Where should this skill run?"
   - "Inline in main conversation (default)"
   - "In a forked subagent (context: fork)"

3. If `context: fork` was chosen, ask **agent type**:
   - "general-purpose (default)"
   - "Explore (read-only, fast)"
   - "Plan (read-only research)"
   - "Custom agent name"

4. **Tool restrictions**: "Restrict tools for this skill?"
   - "No restrictions (default)"
   - "Let me specify allowed tools"
   If user wants to specify, ask for a comma-separated list.

5. **Arguments**: "Does this skill accept arguments?"
   - "No"
   - "Yes — let me provide an argument hint"
   If yes, ask for the hint (e.g. `[filename]`, `[issue-number]`).

## Step 5: Generate the Skill

Use the template in [templates/skill-template.md](templates/skill-template.md) to generate the skill directory. Key rules:

- Create `<scope-path>/<skill-name>/SKILL.md` with YAML frontmatter + markdown body
- Only include frontmatter fields that differ from defaults
- `description` is always included
- If the skill type is "Task", include numbered step placeholders
- If the skill type is "Reference", include bullet-point convention placeholders

For supporting files:
- Ask: "Add supporting files?" with choices: "No", "Yes — reference.md", "Yes — reference.md + scripts/"
- If yes, create stub files with TODO comments

## Step 6: Summary

Print:
```
✅ Skill "<name>" created at <path>/<name>/SKILL.md
Invoke with: /<name>
```

If `context: fork`:
```
Runs in: forked <agent-type> subagent
```

## Additional Resources

- For YAML frontmatter field reference, see [reference.md](reference.md)
- For the generation template, see [templates/skill-template.md](templates/skill-template.md)
