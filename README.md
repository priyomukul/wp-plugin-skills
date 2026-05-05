# wp-plugin-skills

Claude Code marketplace + plugin that bundles the official **[WordPress/agent-skills](https://github.com/WordPress/agent-skills)** collection plus one local skill (`wp-php-coding-standards`) covering WPCS PHP style — the one gap in the upstream collection.

Once installed, every skill below auto-triggers on the appropriate WordPress task — no slash command needed.

## Install

This repo is structured as a Claude Code marketplace containing one plugin. Install in two steps:

### From a local clone

```bash
git clone https://github.com/priyomukul/wp-plugin-skills.git
claude plugin marketplace add ./wp-plugin-skills
claude plugin install wp-plugin-skills@wp-plugin-skills
```

### From GitHub (after the repo is published)

```bash
claude plugin marketplace add priyomukul/wp-plugin-skills
claude plugin install wp-plugin-skills@wp-plugin-skills
```

Verify:

```bash
claude plugin list
```

## Skills bundled

Vendored from `WordPress/agent-skills` (GPL-2.0):

| Skill | What it covers |
|---|---|
| `wordpress-router` | Classifies a WP repo and routes to the right workflow |
| `wp-project-triage` | Detects project type, tooling, versions |
| `wp-plugin-development` | Plugin architecture, hooks, lifecycle, security, settings, data |
| `wp-plugin-directory-guidelines` | WordPress.org submission rules, GPL compliance, naming |
| `wp-block-development` | `block.json`, attributes, deprecations, dynamic rendering |
| `wp-block-themes` | `theme.json`, templates, patterns, style variations |
| `wp-rest-api` | Routes/endpoints, schema, auth, response shaping |
| `wp-interactivity-api` | Frontend `data-wp-*` directives and stores |
| `wp-abilities-api` | Capability-based permissions and REST auth |
| `wp-wpcli-and-ops` | WP-CLI, automation, multisite, search-replace safety |
| `wp-performance` | Profiling, caching, DB optimization, Server-Timing |
| `wp-phpstan` | PHPStan static analysis for WordPress projects |
| `wp-playground` | WordPress Playground for instant local environments |
| `blueprint` | Playground Blueprints for declarative environment setup |
| `wpds` | WordPress Design System |

Local addition:

| Skill | What it covers |
|---|---|
| `wp-php-coding-standards` | WPCS PHP style: formatting, naming, prefixing, file headers, Yoda, spacing, PHPDoc |

## Sync with upstream

The vendored skills are a copy, pinned to a specific upstream commit recorded in
`.upstream-version`. To pull the latest:

```bash
./scripts/sync-upstream.sh                     # latest main
./scripts/sync-upstream.sh v1.2.0              # specific tag
./scripts/sync-upstream.sh <commit-sha>        # specific commit
```

The script preserves `wp-php-coding-standards/` (the local addition) and refreshes everything
else, including `LICENSE`.

## Layout

```
.claude-plugin/marketplace.json              # Marketplace manifest (this repo)
.upstream-version                            # Pinned WordPress/agent-skills commit
LICENSE                                      # GPL-2.0 (from upstream)
scripts/sync-upstream.sh                     # Pull updates from WordPress/agent-skills
plugins/
└── wp-plugin-skills/                        # The plugin
    ├── .claude-plugin/plugin.json
    └── skills/
        ├── wp-php-coding-standards/         # Local: WPCS PHP style
        ├── wordpress-router/                # Vendored from upstream
        ├── wp-plugin-development/
        ├── wp-plugin-directory-guidelines/
        ├── wp-block-development/
        ├── wp-block-themes/
        ├── wp-rest-api/
        ├── wp-interactivity-api/
        ├── wp-abilities-api/
        ├── wp-wpcli-and-ops/
        ├── wp-performance/
        ├── wp-phpstan/
        ├── wp-playground/
        ├── blueprint/
        ├── wpds/
        └── wp-project-triage/
```

## Credits

The 15 vendored skills are © 2026 WordPress Contributors, GPL-2.0-licensed, sourced from
[github.com/WordPress/agent-skills](https://github.com/WordPress/agent-skills). All upstream
skills are unmodified copies. See `LICENSE` for the full GPL-2.0 text.

The `wp-php-coding-standards` skill is original, also GPL-2.0-or-later, sourced from the public
WordPress Coding Standards documentation.
