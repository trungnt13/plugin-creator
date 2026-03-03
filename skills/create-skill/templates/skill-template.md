# Skill Template

Generate a `SKILL.md` using this template. Only include frontmatter fields that differ from defaults.

## Minimal (Reference Skill)

```markdown
---
name: <skill-name>
description: <description>
---

# <Skill Title>

<Instructions for Claude — conventions, patterns, or knowledge to apply.>

- Convention 1
- Convention 2
- Convention 3
```

## Minimal (Task Skill)

```markdown
---
name: <skill-name>
description: <description>
disable-model-invocation: true
---

# <Skill Title>

<Brief overview of what this task does.>

## Steps

1. <Step 1>
2. <Step 2>
3. <Step 3>
```

## With Arguments

```markdown
---
name: <skill-name>
description: <description>
argument-hint: <hint>
---

# <Skill Title>

<Instructions using $ARGUMENTS or $0, $1, etc.>
```

## With Subagent Fork

```markdown
---
name: <skill-name>
description: <description>
context: fork
agent: <agent-type>
allowed-tools: <tools>
---

# <Skill Title>

<Instructions for the forked subagent to execute.>
```

## With Tool Restrictions

```markdown
---
name: <skill-name>
description: <description>
allowed-tools: <comma-separated tools>
---

# <Skill Title>

<Instructions — Claude can only use the specified tools.>
```

## Full Example

```markdown
---
name: fix-issue
description: Fix a GitHub issue by number
argument-hint: [issue-number]
disable-model-invocation: true
context: fork
agent: general-purpose
allowed-tools: Read, Edit, Write, Bash(gh *), Bash(git *)
---

# Fix GitHub Issue

Fix GitHub issue $ARGUMENTS following our coding standards.

## Context

- Issue details: !`gh issue view $0 --json title,body,labels`
- Recent commits: !`git log --oneline -10`

## Steps

1. Read the issue description and understand requirements
2. Find relevant code using Grep and Glob
3. Implement the fix
4. Write tests
5. Create a commit with message "fix: resolve #$0"
```
