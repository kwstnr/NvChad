# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NeoVim configuration repository based on NvChad v2.5. It imports NvChad as a plugin and extends it with custom configurations for multiple language ecosystems including C#/.NET, TypeScript/Angular, JavaScript, and C.

## Architecture

### Plugin System
- **Plugin Manager**: Lazy.nvim with lazy-loading enabled by default
- **Base Framework**: NvChad (imported as a plugin from NvChad/NvChad repo)
- **Entry Point**: `init.lua` bootstraps Lazy.nvim and loads configurations
- **Configuration Loading Order**:
  1. Bootstrap Lazy.nvim if not installed
  2. Load NvChad base plugins (v2.5 branch)
  3. Import custom plugins from `lua/plugins/init.lua`
  4. Load theme and statusline from base46 cache
  5. Load options, autocmds, custom null-ls, keymaps, and mappings

### Directory Structure
```
.
├── init.lua                    # Main entry point
├── lua/
│   ├── chadrc.lua             # NvChad configuration (theme settings)
│   ├── options.lua            # Custom vim options
│   ├── mappings.lua           # Custom key mappings
│   ├── configs/               # Configuration modules
│   │   ├── lazy.lua          # Lazy.nvim settings
│   │   ├── lspconfig.lua     # LSP server configurations
│   │   ├── conform.lua       # Formatter configurations
│   │   ├── dap.lua           # Debug Adapter Protocol configuration
│   │   └── keymaps.lua       # PlantUML keymaps
│   ├── plugins/
│   │   └── init.lua          # Plugin declarations
│   └── custom/
│       └── null-ls.lua       # null-ls formatting/linting setup
└── plantuml-previewer/        # Custom PlantUML preview server
```

## Language Support

### C# / .NET
- **LSP**: csharp-ls (configured in `lua/configs/lspconfig.lua:19-29`)
- **Formatter**: csharpier (via null-ls, but auto-format on save is disabled)
- **Plugin**: easy-dotnet.nvim for .NET-specific workflows
  - Test runner with float view mode
  - Secret management for user secrets
  - Auto-bootstrap namespaces (file-scoped)
- **Commands**:
  - `:Secrets` - Manage user secrets
  - `:TestRunner` - Open test runner UI
  - `:DotnetNew` - Create new .NET projects/files

### TypeScript / JavaScript / Angular
- **LSP**: ts_ls for TypeScript/JavaScript
- **LSP**: angularls for Angular (requires `angular.json` in project root)
- **Formatter**: prettier (via null-ls for js, ts, html, css, json)
- **Completion**: nvim-cmp with LSP, buffer, and path sources
- **Completion Keybinds**:
  - `<CR>` (Enter) - Confirm selection
  - `<Tab>` - Next item
  - `<Shift-Tab>` - Previous item
  - `<C-Space>` - Trigger completion manually
  - `<C-e>` - Abort completion

### C
- **LSP**: clangd (configured for `.c` files)

### Lua
- **Formatter**: stylua (via conform.nvim)

## LSP Configuration Pattern

All LSP servers in `lua/configs/lspconfig.lua` follow this setup:
- Basic servers (html, cssls) use NvChad's default LSP config
- Language-specific servers override `on_attach` to set custom keymaps:
  - `gd` - Go to definition
  - `K` - Hover documentation
  - `<leader>rn` - Rename symbol
  - `<leader>.` - Code actions (quick fixes like auto-imports)

## Debugging (.NET)

Debug Adapter Protocol (DAP) is configured for .NET debugging:
- **Plugin**: nvim-dap with nvim-dap-ui
- **Adapter**: netcoredbg (requires installation: `brew install netcoredbg`)
- **Configuration**: `lua/configs/dap.lua`
- **Debug Keybinds**:
  - `<F5>` - Start/Continue debugging
  - `<F10>` - Step over
  - `<F11>` - Step into
  - `<F12>` - Step out
  - `<leader>b` - Toggle breakpoint
  - `<leader>B` - Set conditional breakpoint
  - `<leader>dt` - Toggle debug UI
  - `<leader>dr` - Open debug REPL
  - `<leader>dl` - Run last debug configuration
- **Usage**: Press F5, then provide path to the compiled DLL (usually in `bin/Debug/`)

## PlantUML Preview System

Custom live preview system for PlantUML diagrams:
- **Location**: `plantuml-previewer/` directory
- **Server**: Express.js server (`server.js`) with live reload via WebSocket
- **Keymaps** (in `lua/configs/keymaps.lua`):
  - `<leader>ps` - Start PlantUML server (only works in `.puml` files)
  - `<leader>po` - Open preview in browser (http://localhost:3000)
  - `<leader>pk` - Stop PlantUML server
- **Dependencies**: Node.js packages (express, chokidar, ws)
- **How it works**:
  1. Watches `.puml` file for changes
  2. Generates SVG using `plantuml` CLI
  3. Notifies browser via WebSocket to reload
  4. Serves diagram on port 3000

## Key Mappings

Global mappings in `lua/mappings.lua`:
- `;` → `:` (CMD mode shortcut)
- `jk` (insert mode) → `<ESC>`

Leader key is space (`<leader>` = ` `)

## Formatting & Linting

### null-ls Configuration
File: `lua/custom/null-ls.lua`
- **Formatters**: csharpier (C#), prettier (JS/TS/HTML/CSS/JSON)
- **Note**: Auto-format on save for C# is disabled due to conflicts with Xappido projects

### conform.nvim Configuration
File: `lua/configs/conform.lua`
- Currently only stylua for Lua files
- Format on save is disabled (commented out)

## Theme

Current theme: Catppuccin (configured in `lua/chadrc.lua`)

## Performance Optimizations

Lazy.nvim is configured to disable many default Vim plugins (netrw, tutor, gzip, etc.) for faster startup. See `lua/configs/lazy.lua:16-44` for the full list.

## Development Notes

- NvChad is used as a plugin dependency, not as a base to fork while the repository is a fork of nvchad/starter
- Custom configurations extend NvChad by importing its modules
- The `.git` directory should be kept (unlike typical NvChad starter usage) since this is a standalone config repository
- Format-on-save is intentionally disabled for most languages to avoid conflicts with specific project requirements
