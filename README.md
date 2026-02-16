# Claude Plugins

A standalone, portable collection of custom Claude Code plugins and development tools.

## What's Inside

### Custom Plugins (`plugins/`)

| Plugin | Type | Description |
|--------|------|-------------|
| **ralph-loop** | Hooks + Commands | Iterative self-referential AI development loops (Ralph Wiggum technique) |

## Installation

### As a Claude Code Marketplace

Register this repo as a plugin marketplace:

```bash
# From GitHub
claude plugin marketplace add --source github --repo YOUR_USER/claude-plugins

# Or from local path
claude plugin marketplace add --source local --path /path/to/claude-plugins
```

Then install individual plugins:

```bash
claude plugin install ralph-loop
# etc.
```

### Manual Installation (Individual Plugins)

Copy any plugin directory into your Claude Code plugins path:

```bash
# Example: Install ralph-loop
cp -r plugins/ralph-loop ~/.claude/plugins/installed/ralph-loop
```

## Plugin Architecture

Each plugin follows the Claude Code plugin spec:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Manifest (name, description, author)
├── .mcp.json                # MCP server config (optional)
├── commands/                # Slash commands (optional)
│   └── command-name.md
├── skills/                  # Knowledge modules (optional)
│   └── skill-name/
│       └── SKILL.md
├── hooks/                   # Lifecycle hooks (optional)
│   ├── hooks.json
│   └── *.sh / *.py
├── agents/                  # Sub-agents (optional)
│   └── agent-name.md
└── README.md
```

## Adding New Plugins

1. Create a directory under `plugins/`
2. Add `.claude-plugin/plugin.json` with name, description, author
3. Add `.mcp.json` for MCP server config (if applicable)
4. Add `commands/`, `skills/`, `hooks/`, `agents/` as needed
5. Update `.claude-plugin/marketplace.json` with the new entry

## License

MIT licensed.
