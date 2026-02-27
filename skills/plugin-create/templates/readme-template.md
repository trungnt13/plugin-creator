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
- **<agent-name>**: <description extracted from first heading>

### Skills
- **<skill-name>**: <description extracted from frontmatter or first heading>

### Commands
- **/<command-name>**: <description extracted from first line>

## Source

This plugin was scaffolded from:
- `.claude/` configuration: <yes/no>
- `.github/` configuration: <yes/no>
```
