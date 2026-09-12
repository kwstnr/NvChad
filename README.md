# Personal Neovim configuration

NvChad v2.5 configuration for Rust, C#/.NET, TypeScript/Angular, C, and Lua.
NvChad itself is a plugin; this repository owns the configuration and keeps its
Git history. `main` is the intended shared baseline across machines.

## Installation

Clone this repository wherever you keep development projects, then run:

```sh
sh scripts/link-config.sh
```

This backs up an existing `~/.config/nvim` directory and replaces it with a
symlink to this checkout. Editing either location then edits the same files.
Keep the checkout in place. Git commands work from either location.
Close Neovim before switching the configuration.

The installer honors `XDG_CONFIG_HOME` if set. The PlantUML preview keymap
currently assumes the default `~/.config/nvim` location and macOS.

## Everyday workflow

```sh
cd ~/.config/nvim
git status
git pull --ff-only
```

Commit configuration changes and `lazy-lock.json` here, then push and pull on
your other machines. `:Lazy restore` installs the versions recorded in the
lockfile; `:Lazy update` changes those versions and should be a deliberate,
separately tested update.

The baseline preserves the existing Rust setup and the active machine's
Treesitter workaround and plugin pins. Language tools such as rust-analyzer,
Clippy, and formatters must also be installed on each machine.

The existing migration notes are preserved in
[docs/NVCHAD_UPDATE_GUIDE.md](docs/NVCHAD_UPDATE_GUIDE.md) as historical notes,
not a validated upgrade procedure. They describe a separate future migration;
do not apply their upgrade or cache-deletion steps as part of this baseline.

## Credits

Based on the NvChad starter, which was inspired by LazyVim's starter.
