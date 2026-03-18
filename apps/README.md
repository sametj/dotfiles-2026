# Apps Directory

This directory is now the primary home for dotfile-managed apps.

Each app lives at:

```text
apps/<app>/
├── manifest.yaml
├── files/
└── hooks/
```

- `manifest.yaml` describes the app, its install metadata, and notes.
- `files/` mirrors the final layout under `$HOME`.
- `hooks/` is reserved for app-specific helper scripts when metadata is not enough.

Current migrated config apps:

- `git`
- `ghostty`
- `nvim`
- `tmux`
- `zsh`

List discovered app manifests with `./bootstrap/install.sh --list-apps`.
Use `scripts/add-app <name>` to scaffold a new app.
