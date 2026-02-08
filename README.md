# Claude Plugins

A standalone, portable collection of Claude Code plugins — curated third-party MCP integrations and custom development tools.

## What's Inside

### Custom Plugins (`plugins/`)

| Plugin | Type | Description |
|--------|------|-------------|
| **ralph-loop** | Hooks + Commands | Iterative self-referential AI development loops (Ralph Wiggum technique) |

### External / Third-Party Plugins (`external_plugins/`)

| Plugin | MCP Type | Provider | Description |
|--------|----------|----------|-------------|
| **playwright** | stdio | Microsoft | Browser automation and E2E testing |
| **github** | HTTP | GitHub | Repository management, PRs, issues |
| **gitlab** | HTTP | GitLab | DevOps platform, MRs, CI/CD |
| **slack** | SSE | Slack | Workspace search, channels, threads |
| **asana** | SSE | Asana | Project management, tasks |
| **linear** | HTTP | Linear | Issue tracking, projects |
| **stripe** | HTTP | Stripe | Payment integration + best practices skill |
| **supabase** | HTTP | Supabase | Database, auth, storage, real-time |
| **firebase** | stdio | Google | Firestore, auth, functions, hosting |
| **context7** | stdio | Upstash | Up-to-date documentation lookup |
| **serena** | stdio | Oraios | Semantic code analysis via LSP |
| **greptile** | HTTP | Greptile | AI code review for PRs |
| **laravel-boost** | stdio | Laravel | Laravel dev toolkit |

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
claude plugin install playwright
claude plugin install stripe
# etc.
```

### Manual Installation (Individual Plugins)

Copy any plugin directory into your Claude Code plugins path:

```bash
# Example: Install ralph-loop
cp -r plugins/ralph-loop ~/.claude/plugins/installed/ralph-loop

# Example: Install playwright
cp -r external_plugins/playwright ~/.claude/plugins/installed/playwright
```

### As MCP Servers Only

If you just want the MCP server configs without the full plugin system:

```bash
# Add a single MCP server from its .mcp.json
claude mcp add-json playwright "$(cat external_plugins/playwright/.mcp.json)"
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

### MCP Server Types

- **stdio** — Local process (e.g., `npx @playwright/mcp@latest`)
- **HTTP** — REST endpoint with optional auth headers
- **SSE** — Server-Sent Events with OAuth flow

### Environment Variables for Auth

Some plugins require environment variables:

```bash
# GitHub
export GITHUB_PERSONAL_ACCESS_TOKEN="ghp_..."

# Greptile
export GREPTILE_API_KEY="..."
```

Check each plugin's `.mcp.json` for `${ENV_VAR}` placeholders.

## Adding New Plugins

1. Create a directory under `external_plugins/` or `plugins/`
2. Add `.claude-plugin/plugin.json` with name, description, author
3. Add `.mcp.json` for MCP server config (if applicable)
4. Add `commands/`, `skills/`, `hooks/`, `agents/` as needed
5. Update `.claude-plugin/marketplace.json` with the new entry

## License

Individual plugins retain their original licenses. This collection is MIT licensed.
