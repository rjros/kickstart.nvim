# Custom Neovim Configuration

Neovim setup optimized for C/C++/Python development with integrated tools.

## ✨ Features

- 🚀 **Modern Development Environment**
  - Full LSP support (clangd, pyright)
  - Treesitter syntax highlighting
  - Auto-completion with blink.cmp
  - Integrated debugging support

- 🛠️ **Integrated Tools**
  - **tmux** - Terminal multiplexer
  - **zsh** with Oh My Zsh and Powerlevel10k
  - **lazygit** - Beautiful git TUI
  - **yazi** - Fast file manager
  - **Nerd Fonts** - Beautiful icons everywhere

- 📁 **Modular Configuration**
  - Based on kickstart.nvim
  - Plugin configurations in separate files

## 🚀 Quick Install
```bash
git clone https://github.com/rjros/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
cd "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
bash install.sh
```

## 📖 Documentation

- [Installation Guide](INSTALL.md) - Complete step-by-step installation
- [Keybindings](KEYBINDINGS.md) - All keybindings reference

## 🎯 Requirements

- Ubuntu 24.04 (or similar Linux)
- Git, curl, wget
- Terminal with Nerd Font support

## ⚡ Quick Start

After installation:
```bash
# Start tmux
tmux

# Open Neovim
nvim

# Inside Neovim:
Space + e    # File manager (yazi)
Space + lg   # Git UI (lazygit)
Space + sf   # Find files
```

## 📦 What's Included

### Languages
- C/C++ (clangd, clang-format)
- Python (pyright, black)
- Lua (lua_ls, stylua)

### Tools
- tmux (terminal multiplexer)
- zsh (shell)
- lazygit (git interface)
- yazi (file manager)
- Telescope (fuzzy finder)
- Mason (LSP installer)

### Plugins
- lazy.nvim (plugin manager)
- nvim-lspconfig (LSP)
- nvim-treesitter (syntax highlighting)
- blink.cmp (completion)
- telescope.nvim (fuzzy finder)
- gitsigns.nvim (git integration)
- And more...

## 🎨 Customization

Configuration structure:
```
~/.config/nvim/
├── init.lua              # Main config
├── lua/
│   └── plugins/          # Plugin configs
│       ├── lazygit.lua
│       ├── yazi.lua
│       └── ...
└── INSTALL.md           # Documentation
```

Edit `init.lua` or add files to `lua/plugins/` to customize.

<!-- ## 🐛 Troubleshooting -->
<!---->
<!-- See [INSTALL.md](INSTALL.md#troubleshooting) for common issues and solutions. -->

## 📝 License

MIT

## 🙏 Credits

Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) by TJ DeVries.

Custom configuration and integration by [@rjros](https://github.com/rjros).
