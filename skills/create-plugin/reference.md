# Reference: Adaptation Rules & Error Handling

## Adaptation Rules (.github/ → Claude Code)

When converting files from `.github/` format to Claude Code plugin format:

### copilot-instructions.md
- Content is usually compatible — copy as-is
- Place in `instructions/` or convert to a skill if it contains actionable instructions

### Agent Files
- Copilot agents may use YAML frontmatter with `description:` — keep it, Claude Code supports it
- If the agent references Copilot-specific tools (e.g. `github.copilot.*`), add a comment noting the incompatibility:
  ```markdown
  <!-- Note: Some tool references were adapted from GitHub Copilot format -->
  ```

### Skill Files
- Same adaptation rules as agents
- Ensure each skill ends up in its own `skills/<name>/SKILL.md` directory with frontmatter

### General Rules
- Preserve all content; only add compatibility notes where needed
- Convert any Copilot-specific YAML frontmatter keys to Claude Code equivalents
- If unsure whether something is compatible, keep it and add a comment

## Adaptation Rules (~/.claude/ → Plugin)

When converting personal (user-level) configs to plugin format:

### Personal Skills
- Copy the entire skill directory (`~/.claude/skills/<name>/`) into `skills/<name>/`
- Label with `[personal]` when presenting to user for selection

### Personal Agents
- Copy `.md` files from `~/.claude/agents/` into `agents/`
- Label with `[personal]` when presenting to user for selection

## Component-Specific Rules

### Hooks
- Extract only the `hooks` key from `settings.json` / `settings.local.json`
- Place in `hooks/hooks.json` with the full hook structure
- Validate that hook `command` paths are relative and exist
- If commands reference absolute paths, warn the user

### MCP Configs
- Copy `.mcp.json` as-is to plugin root
- If environment variables are referenced (`${VAR}`), note that users will need to set them
- Warn about any absolute paths in server commands

### LSP Configs
- Copy `.lsp.json` as-is to plugin root
- Note that users must have the language server binary installed

## Error Handling

### Output directory already exists
Ask the user: overwrite, merge, or choose a different name.

### File can't be read
Skip it, warn the user, and continue with remaining files.

### No items selected
Confirm the user wants to create an empty plugin shell (manifest + README only).

### Git user not available
Ask the user for an author name to use in plugin.json.

### Hook command paths not found
Warn the user that hook scripts need to be included or paths updated.
