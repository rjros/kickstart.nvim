# Installation Guide - Custom Neovim Setup

Complete setup guide for C/C++/Python development with Neovim, tmux, zsh, and modern tools.

## Table of Contents

- [System Requirements](#system-requirements)
- [Quick Start](#quick-start)
- [Detailed Installation](#detailed-installation)
  - [1. System Dependencies](#1-system-dependencies)
  - [2. Neovim](#2-neovim)
  - [3. tmux](#3-tmux)
  - [4. zsh with Oh My Zsh](#4-zsh-with-oh-my-zsh)
  - [5. Nerd Fonts](#5-nerd-fonts)
  - [6. lazygit](#6-lazygit)
  - [7. yazi](#7-yazi)
  - [8. Neovim Configuration](#8-neovim-configuration)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)

---

## System Requirements

- Ubuntu 24.04 or similar Debian-based Linux
- Git
- Curl
- Internet connection

---

## Quick Start (TO BE TESTED)

For experienced user, run this all-in-one script:
```bash
# Download and run installation script
curl -fsSL https://raw.githubusercontent.com/rjros/kickstart.nvim/main/install.sh | bash
```

For step-by-step installation, continue reading.

---

## Detailed Installation

### 1. System Dependencies

**Install base development tools:**
```bash
sudo apt update
sudo apt install -y \
  build-essential \
  git \
  curl \
  unzip \
  tar \
  wget \
  gcc \
  g++ \
  clang \
  clangd \
  python3 \
  python3-pip \
  ripgrep \
  fd-find \
  nodejs \
  npm
```

**Verify installations:**
```bash
gcc --version
g++ --version
clangd --version
python3 --version
node --version
```

---

### 2. Neovim

**Install Neovim (latest stable):**
```bash
# Download latest stable release
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz

# Extract
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

# Add to PATH
echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
source ~/.bashrc

# Clean up
rm nvim-linux64.tar.gz
```

**Verify:**
```bash
nvim --version
# Should show: NVIM v0.10.0 or higher
```

---

### 3. tmux

**Install tmux:**
```bash
sudo apt install -y tmux
```

**Create configuration:**
```bash
cat > ~/.tmux.conf << 'EOF'
# Change prefix from Ctrl-b to Ctrl-a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Enable mouse support
set -g mouse on

# Start windows and panes at 1
set -g base-index 1
setw -g pane-base-index 1

# Split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Reload config
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Enable 256 colors
set -g default-terminal "screen-256color"

# Vim-like pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
EOF
```

**Verify:**
```bash
tmux -V
# Should show: tmux 3.x
```

---

### 4. zsh with Oh My Zsh

**Install zsh:**
```bash
sudo apt install -y zsh
```

**Install Oh My Zsh:**
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**When prompted, type `Y` to set zsh as default shell.**

**Install Powerlevel10k theme:**
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

**Install useful plugins:**
```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

**Configure ~/.zshrc:**
```bash
cat >> ~/.zshrc << 'EOF'

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Aliases
alias v="nvim"
alias vim="nvim"
alias lg="lazygit"
alias fm="yazi"
alias cpp20="g++ -std=c++20 -Wall -Wextra"
alias py="python3"

# Quick navigation
alias ..="cd .."
alias ...="cd ../.."
alias projects="cd ~/projects"
alias scripts="cd ~/scripts"
EOF
```

**Reload config:**
```bash
source ~/.zshrc
```

**Configure Powerlevel10k:**
```bash
p10k configure
```

**Verify:**
```bash
echo $SHELL
# Should show: /usr/bin/zsh
```

---

### 5. Nerd Fonts

**Install JetBrainsMono Nerd Font:**
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip
rm JetBrainsMono.zip
fc-cache -fv
```

**Configure your terminal:**
1. Open terminal settings/preferences
2. Set font to: **JetBrainsMono Nerd Font** (or **JetBrainsMono Nerd Font Mono**)
3. Close and reopen terminal

**Verify:**
```bash
echo "  "
# Should show folder, git, and file icons
```

---

### 6. lazygit

**Install lazygit:**
```bash
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz
```

**Verify:**
```bash
lazygit --version
```

---

### 7. yazi

**Install Rust (required for yazi):**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

**Install yazi and ya:**
```bash
cargo install --force yazi-build
```

**Add cargo bin to PATH:**
```bash
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Create yazi configuration:**
```bash
mkdir -p ~/.config/yazi
```

**Create ~/.config/yazi/yazi.toml:**
```bash
cat > ~/.config/yazi/yazi.toml << 'EOF'
[manager]
ratio = [1, 4, 3]
show_hidden = false
sort_by = "alphabetical"
sort_dir_first = true

[preview]
max_width = 600
max_height = 900
tab_size = 2

[opener]
edit = [
  { run = 'nvim "$@"', block = true, for = "linux" },
]
EOF
```

**Create ~/.config/yazi/keymap.toml:**
```bash
cat > ~/.config/yazi/keymap.toml << 'EOF'
[manager]
keymap = [
  { on = [ "g", "h" ], run = "cd ~", desc = "Go home" },
  { on = [ "g", "p" ], run = "cd ~/projects", desc = "Go to projects" },
  { on = [ "g", "s" ], run = "cd ~/scripts", desc = "Go to scripts" },
  { on = [ "z", "h" ], run = "hidden toggle", desc = "Toggle hidden" },
]
EOF
```

**Verify:**
```bash
yazi --version
ya --version
```

---

### 8. Neovim Configuration

**Backup existing config (if any):**
```bash
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.backup 2>/dev/null
mv ~/.local/state/nvim ~/.local/state/nvim.backup 2>/dev/null
mv ~/.cache/nvim ~/.cache/nvim.backup 2>/dev/null
```

**Clone this repository:**
```bash
git clone https://github.com/rjros/kickstart.nvim.git ~/.config/nvim
```

**Start Neovim (plugins will auto-install):**
```bash
nvim
```

**Wait for lazy.nvim to install all plugins.**

**Install LSP servers via Mason:**
```vim
:Mason
```

**Install these (press `i` on each):**
- clangd (C/C++)
- pyright (Python)
- lua_ls (Lua)
- stylua (Lua formatter)
- clang-format (C/C++ formatter)
- black (Python formatter)

**Or install directly:**
```vim
:MasonInstall clangd pyright lua_ls stylua clang-format black
```

**Install Treesitter parsers:**
```vim
:TSInstall c cpp python lua vim vimdoc markdown bash
```

**Quit and reopen Neovim:**
```vim
:qa
nvim
```

---

## Verification

### Test Each Component

**1. tmux:**
```bash
tmux
# Press Ctrl-a | to split vertically
# Press Ctrl-a - to split horizontally
# Press Ctrl-a d to detach
tmux attach
exit
```

**2. zsh with icons:**
```bash
cd ~/projects
# Should see colorful prompt with  and  icons
```

**3. Neovim:**
```bash
nvim test.cpp
```

**Test keybindings:**
- `Space + e` - yazi file manager
- `Space + lg` - lazygit
- `Space + sf` - find files
- `Space + sg` - grep search

**4. C++ autocomplete:**

Create test file:
```bash
cat > test.cpp << 'EOF'
#include <iostream>
#include <vector>

int main() {
    std::vector<int> v = {1, 2, 3};
    v.
    return 0;
}
EOF
```

Open in Neovim:
```bash
nvim test.cpp
```

After `v.` type, autocomplete should show: `push_back`, `size`, `empty`, etc.

**5. LSP features:**
- Hover: `K` on a symbol
- Go to definition: `grd`
- Find references: `grr`
- Rename: `grn`

---

## Troubleshooting

### Neovim: No autocomplete for std::

**Create .clangd in your project:**
```bash
cd ~/your-project
cat > .clangd << 'EOF'
CompileFlags:
  Add:
    - -std=c++20
    - -Wall
    - -Wextra
EOF
```

**Restart Neovim:**
```vim
:LspRestart
```

### Icons showing as boxes

**Problem:** Terminal not using Nerd Font

**Solution:**
1. Go to terminal settings
2. Set font to "JetBrainsMono Nerd Font"
3. Close and reopen terminal

### zsh not default shell
```bash
chsh -s $(which zsh)
```

Log out and log back in.

### yazi: "ya command not found"
```bash
# Make sure cargo bin is in PATH
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify
which ya
```

### Mason: clangd won't install

**Install system-wide as fallback:**
```bash
sudo apt install clangd
```

---

## Complete Workflow

**Typical development session:**
```bash
# Start tmux
tmux

# Pane 1: Open Neovim
nvim

# Inside Neovim:
# - Space + e → browse files (yazi)
# - Space + sf → search files (Telescope)
# - Space + lg → git operations (lazygit)
# - Space + / → search in current buffer

# Pane 2: Split for git (Ctrl-a |)
lazygit

# Pane 3: Split for terminal (Ctrl-a -)
# Use for compilation, running programs
```

---

## Key Bindings Reference

### tmux
- `Ctrl-a |` - Split vertically
- `Ctrl-a -` - Split horizontally
- `Ctrl-a h/j/k/l` - Navigate panes
- `Ctrl-a d` - Detach

### Neovim (Leader = Space)
- `Space + e` - yazi (file manager)
- `Space + lg` - lazygit
- `Space + sf` - Search files
- `Space + sg` - Search by grep
- `Space + /` - Search in buffer
- `K` - Hover documentation
- `grd` - Go to definition
- `grr` - Find references
- `grn` - Rename symbol

### yazi
- `j/k` - Move up/down
- `h/l` - Back/forward
- `gh` - Go home
- `Space` - Select
- `y` - Copy
- `p` - Paste
- `d` - Delete
- `q` - Quit

---

## Project Structure
```
~/.config/nvim/
├── init.lua                 # Main config
├── lua/
│   └── plugins/             # Plugin configurations
│       ├── lazygit.lua
│       ├── yazi.lua
│       ├── treesitter.lua
│       └── ...
├── .clangd                  # C/C++ LSP config (per project)
└── INSTALL.md              # This file

~/.config/yazi/
├── yazi.toml               # yazi main config
├── keymap.toml             # yazi keybindings
└── theme.toml              # yazi colors

~/.tmux.conf                # tmux config
~/.zshrc                    # zsh config
```

---

## Updates

**Update Neovim plugins:**
```vim
:Lazy update
```

**Update Mason tools:**
```vim
:MasonUpdate
```

**Update Oh My Zsh:**
```bash
omz update
```

**Update yazi:**
```bash
cargo install --force yazi-build
```

---

## Credits

- Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- Custom configuration for C/C++/Python development
- Integrated with tmux, zsh, lazygit, and yazi

---

## License

MIT
