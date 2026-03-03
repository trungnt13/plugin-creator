# README Template

Generate a `README.md` for the scaffolded plugin using this template. Only include sections that have content.

---

```markdown
# <Plugin Name>

<description>

## Installation

```bash
/plugin install <path-or-repo>
\```

Or test locally:

```bash
claude --plugin-dir ./<plugin-name>
\```

## Contents

### Agents
- **<agent-name>**: <description extracted from first heading or frontmatter>

### Skills
- **<skill-name>**: <description extracted from frontmatter or first heading>

### Commands
- **/<command-name>**: <description extracted from first line>

### Hooks
- <hook-event>: <brief description of what the hook does>

### MCP Servers
- **<server-name>**: <command used to run the server>

### LSP Servers
- **<language>**: <command used to run the server>

## Source

This plugin was scaffolded from:
- `.claude/` configuration: <yes/no>
- `~/.claude/` configuration: <yes/no>
- `.github/` configuration: <yes/no>
```
