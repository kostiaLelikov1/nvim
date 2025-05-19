# Neovim Configuration

A modern, optimized Neovim configuration with LSP support, Copilot integration, and a focus on performance.

## Features

- **LSP Integration**: Native LSP support with Mason for easy language server management
- **Copilot Integration**: GitHub Copilot for AI-assisted coding with Copilot Chat
- **Performance Optimizations**: Optimized for speed and responsiveness
- **Modern UI**: Clean and functional interface with statusline and icons
- **File Navigation**: Fast file browsing with Telescope and nvim-tree
- **Keybindings**: Intuitive keybindings with which-key integration

## Structure

- `lua/klelikov/core/`: Core configuration files
  - `init.lua`: Main initialization file
  - `keymaps.lua`: Global keymaps
  - `options.lua`: Vim options
  - `performance.lua`: Performance optimizations
- `lua/klelikov/plugins/`: Plugin configurations
  - `lsp/`: LSP-related plugins
  - Various plugin configuration files

## Key Mappings

### General

- `<Space>`: Leader key
- `<leader>f`: Find (Telescope)
- `<leader>g`: Git operations
- `<leader>l`: LSP operations
- `<leader>c`: Copilot operations
- `<leader>e`: Explorer (nvim-tree)

### LSP

- `K`: Show hover documentation
- `gd`: Go to definition
- `gr`: Find references
- `<leader>lr`: Find references
- `<leader>ld`: Find definitions
- `<leader>ls`: Find document symbols

### Git

- `<leader>gs`: Stage hunk
- `<leader>gr`: Reset hunk
- `<leader>gb`: Blame line
- `<leader>gp`: Preview hunk

### Copilot

- `<leader>cc`: Toggle Copilot Chat
- `<leader>ce`: Explain code
- `<leader>cr`: Review code
- `<leader>ct`: Generate tests

## Installation

1. Clone this repository to your Neovim configuration directory:
   ```
   git clone https://github.com/yourusername/nvim.git ~/.config/nvim
   ```

2. Start Neovim:
   ```
   nvim
   ```

3. Lazy.nvim will automatically install all plugins on the first run.

## Requirements

- Neovim >= 0.9.0
- Git
- Node.js >= 16.x (for Copilot)
- A Nerd Font (for icons)
