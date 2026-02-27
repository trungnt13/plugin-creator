# plugin-creator

A Claude Code plugin that scaffolds new plugins from existing repository configurations. Supports both `.claude/` and `.github/` (GitHub Copilot CLI) source formats.

## What it does

When invoked, the `scaffold-plugin` skill:

1. **Scans** your repo's `.claude/` and `.github/` directories for agents, skills, instructions, and commands
2. **Prompts** you to select which items to include in the new plugin
3. **Generates** a properly structured Claude Code plugin ready to install

## Installation

```bash
/plugin install /path/to/plugin-creator
```

## Usage

Ask Claude to create a plugin:

```
scaffold a plugin called "my-tools"
```

Or more specifically:

```
create a plugin from my repo's agents and skills
```

The skill will guide you through selecting which components to include.

## Supported Source Formats

| Source | Path | What's scanned |
|--------|------|----------------|
| Claude Code | `.claude/agents/*.md` | Agent definitions |
| Claude Code | `.claude/skills/*.md` | Skill definitions |
| Claude Code | `.claude/instructions.md` | Project instructions |
| Claude Code | `.claude/instructions/*.md` | Modular instructions |
| Claude Code | `.claude/commands/*.md` | Slash commands |
| Claude Code | `.claude/settings.json` | Settings |
| GitHub Copilot | `.github/agents/*.md` | Agent definitions |
| GitHub Copilot | `.github/skills/*.md` | Skill definitions |
| GitHub Copilot | `.github/copilot-instructions.md` | Project instructions |
| GitHub Copilot | `.github/instructions/*.md` | Modular instructions |

## Generated Plugin Structure

```
my-plugin/
├── plugin.json          # Plugin manifest
├── README.md            # Auto-generated docs
├── agents/              # Selected agents
│   └── *.md
├── skills/              # Selected skills
│   └── *.md
├── instructions/        # Selected instructions
│   └── *.md
└── commands/            # Selected commands
    └── *.md
```

## Example

Given a repo with:
```
.claude/
├── agents/
│   ├── code-reviewer.md
│   └── test-writer.md
├── skills/
│   └── deploy.md
└── instructions.md
```

Running the scaffold skill produces an interactive session where you pick which items to include, and generates a ready-to-install plugin.

## License

MIT
