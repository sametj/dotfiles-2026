# Adding Apps

This guide describes the new app-oriented structure introduced alongside the existing bootstrap tasks.

## Quick Start

Create a new app scaffold:

```bash
scripts/add-app ghostty
```

That creates:

```text
apps/ghostty/
├── manifest.yaml
├── files/
└── hooks/
```

## App Checklist

After scaffolding a new app:

1. Fill in `apps/<app>/manifest.yaml`
2. Put tracked config under `apps/<app>/files/`
3. Add optional scripts under `apps/<app>/hooks/` only if the manifest is not enough
4. Decide whether the app is:
   - config only
   - install only
   - install + config
5. Add local/private instructions to `notes` instead of committing secrets

## Files Layout

The `files/` directory should reflect where files land under `$HOME`.

Examples:

- `apps/git/files/.gitconfig`
- `apps/zsh/files/.zshrc`
- `apps/nvim/files/.config/nvim/init.lua`

## Manifest Example

```yaml
name: ghostty
description: Ghostty terminal config
platforms:
  - linux
  - macos
install:
  linux:
    packages: []
  macos:
    brew: []
link:
  strategy: symlink-tree
checks: []
notes: []
```

## When to Add a Hook

Only add shell hooks when the app needs logic that cannot be captured as plain metadata.

Good examples:

- download a pinned GitHub release asset
- print a machine-local next step
- perform a one-time migration

Bad examples:

- writing tracked config files during bootstrap
- embedding all install logic in shell instead of manifest data

## Migration Note

The current repo still uses `bootstrap/tasks/*.sh` for installation. New app scaffolds are meant to establish the next structure without forcing an all-at-once rewrite.
