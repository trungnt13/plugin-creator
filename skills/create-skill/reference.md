# Reference: Skill Frontmatter Fields

> Source: [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)

## YAML Frontmatter Fields

All fields are optional. Only `description` is recommended.

| Field | Required | Description |
|-------|----------|-------------|
| `name` | No | Display name. Lowercase letters, numbers, hyphens only (max 64 chars). Defaults to directory name. |
| `description` | Recommended | What the skill does and when to use it. Claude uses this for auto-invocation. |
| `argument-hint` | No | Hint shown during autocomplete (e.g. `[issue-number]`, `[filename] [format]`). |
| `disable-model-invocation` | No | `true` = only user can invoke. Default: `false`. |
| `user-invocable` | No | `false` = only Claude can invoke (hidden from `/` menu). Default: `true`. |
| `allowed-tools` | No | Tools Claude can use without asking permission when skill is active. |
| `model` | No | Model to use when skill is active. |
| `context` | No | Set to `fork` to run in a forked subagent context. |
| `agent` | No | Which subagent type when `context: fork` is set (`Explore`, `Plan`, `general-purpose`, or custom). |
| `hooks` | No | Hooks scoped to this skill's lifecycle. |

## String Substitutions

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | All arguments passed when invoking the skill. |
| `$ARGUMENTS[N]` | Access specific argument by 0-based index. |
| `$N` | Shorthand for `$ARGUMENTS[N]` (e.g. `$0`, `$1`). |
| `${CLAUDE_SESSION_ID}` | Current session ID. |

## Dynamic Context Injection

Use `` !`command` `` syntax to run shell commands before the skill content is sent to Claude. The output replaces the placeholder.

Example:
```
Current branch: !`git branch --show-current`
Recent changes: !`git log --oneline -5`
```

## Skill Scopes (Priority Order)

1. **Enterprise** — managed settings (all users in org)
2. **Personal** — `~/.claude/skills/<name>/SKILL.md`
3. **Project** — `.claude/skills/<name>/SKILL.md`
4. **Plugin** — `<plugin>/skills/<name>/SKILL.md` (namespaced as `plugin-name:skill-name`)

## Skill Directory Structure

```
my-skill/
├── SKILL.md           # Main instructions (required)
├── reference.md       # Detailed reference docs
├── examples/          # Example outputs
│   └── sample.md
├── templates/         # Templates for Claude to fill
│   └── template.md
└── scripts/           # Scripts Claude can execute
    └── helper.sh
```

Reference supporting files from SKILL.md so Claude knows what they contain and when to load them.

## Invocation Control

| Frontmatter | User invokes | Claude invokes | When loaded |
|------------|-------------|---------------|-------------|
| (default) | Yes | Yes | Description always in context |
| `disable-model-invocation: true` | Yes | No | Not in context until invoked |
| `user-invocable: false` | No | Yes | Description always in context |
