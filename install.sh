#!/bin/bash

# Automated Installation Script
# For Custom Neovim Development Setup

set -e  # Exit on error

echo "=========================================="
echo "  Custom Neovim Development Setup"
echo "  C/C++/Python with tmux, zsh, yazi"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    error "This script is for Linux only"
    exit 1
fi

# 1. System Dependencies
info "Installing system dependencies..."
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
  npm \
  xclip \
  tmux \
  zsh

# 2. Neovim
info "Installing Neovim v0.11.5..."

# Cleanup
sudo apt remove neovim -y 2>/dev/null
sudo rm -rf /opt/nvim-linux64 /opt/nvim
sudo rm -f /usr/local/bin/nvim

# Download AppImage
cd /tmp
if wget -q --show-progress -O nvim.appimage \
  https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.appimage; then
    
    chmod u+x nvim.appimage
    
    # Test
    if ./nvim.appimage --version >/dev/null 2>&1; then
        sudo mv nvim.appimage /usr/local/bin/nvim
        info "✓ Neovim installed: $(nvim --version | head -1)"
    else
        warn "AppImage won't run, extracting..."
        ./nvim.appimage --appimage-extract >/dev/null
        if [ -d squashfs-root ]; then
            sudo mv squashfs-root /opt/nvim
            sudo ln -s /opt/nvim/usr/bin/nvim /usr/local/bin/nvim
            rm nvim.appimage
            info "✓ Neovim extracted and installed"
        else
            error "Extraction failed"
            sudo apt update && sudo apt install -y neovim
        fi
    fi
else
    error "Download failed"
    sudo apt update && sudo apt install -y neovim
fi

# 3. tmux config
info "Configuring tmux..."
if [ ! -f ~/.tmux.conf ]; then
    cat > ~/.tmux.conf << 'EOF'

## Modified tmux conf. changed prefix to C+, enable mouse support, start windows at 1

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

# Enable status bar
set -g status on

# Status bar background / foreground
set -g status-style bg=colour234,fg=colour250
EOF
else
    warn "tmux config already exists, skipping"
fi

# 4. Oh My Zsh
info "Installing Oh My Zsh..."
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    info "Oh My Zsh already installed"
fi

# 5. Powerlevel10k
info "Installing Powerlevel10k theme..."
if [ ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# 6. zsh plugins
info "Installing zsh plugins..."
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# 7. Configure .zshrc
info "Configuring zsh..."
if ! grep -q "powerlevel10k" ~/.zshrc; then
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
fi

if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
fi

# Add aliases if not present
if ! grep -q 'alias v="nvim"' ~/.zshrc; then
    cat >> ~/.zshrc << 'EOF'

# Custom aliases
alias v="nvim"
alias vim="nvim"
alias lg="lazygit"
alias fm="yazi"
#alias cpp20="g++ -std=c++20 -Wall -Wextra"
alias py="python3"
alias ..="cd .."
alias ...="cd ../.."
EOF
fi

# 8. Nerd Font
info "Installing JetBrainsMono Nerd Font..."
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
if [ ! -f "JetBrainsMonoNerdFont-Regular.ttf" ]; then
    curl -fLo "JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
    unzip -o JetBrainsMono.zip
    rm JetBrainsMono.zip
    fc-cache -fv
else
    info "Nerd Font already installed"
fi
cd ~

# 9. lazygit
info "Installing lazygit..."
if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
else
    info "lazygit already installed"
fi

# 10. Rust (for yazi)
info "Installing Rust..."
if ! command -v cargo &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
else
    info "Rust already installed"
fi

# Add cargo to PATH
if ! grep -q "cargo/bin" ~/.zshrc; then
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
fi
export PATH="$HOME/.cargo/bin:$PATH"

# 11. yazi
info "Installing yazi..."
if ! command -v yazi &> /dev/null || ! command -v ya &> /dev/null; then
    cargo install --force yazi-build
else
    info "yazi already installed"
fi

# 12. yazi config
info "Configuring yazi..."
mkdir -p ~/.config/yazi
if [ ! -f ~/.config/yazi/yazi.toml ]; then
    cat > ~/.config/yazi/yazi.toml << 'EOF'

[manager]
# Layout (columns ratio)
ratio = [1, 4, 3]

# Show hidden files by default
show_hidden = false

# Sort options
sort_by = "alphabetical"
sort_sensitive = false
sort_reverse = false
sort_dir_first = true

# Line mode (show file info)
linemode = "size"

# Show symlink target
show_symlink = true

[preview]
# Image preview
image_filter = "triangle"
image_quality = 90

# Maximum file size for preview (in bytes, 10MB)
max_width = 600
max_height = 900

# Tab size for text preview
tab_size = 2

[opener]
# How to open files

# Text files - open in Neovim
edit = [
  { run = 'nvim "$@"', block = true, for = "linux" },
]
EOF
fi


# 13. yazi theme config
info "Configuring yazi theme..."
if [ ! -f ~/.config/yazi/theme.toml ]; then
    cat > ~/.config/yazi/theme.toml << 'EOF'

#theme.toml -Color scheme

[manager]

# Highlighting colors
cwd = { fg = "cyan" }

# Hovered item
hovered = { fg = "black", bg = "lightblue" }
preview_hovered = { underline = true }

# Selection
selected = { fg = "yellow", bg = "reset" }

# File types
folder = { fg = "blue" }
symlink = { fg = "cyan" }
executable = { fg = "green" }

# Status line
border_symbol = "│"
border_style = { fg = "gray" }

[status]
separator_open = ""
separator_close = ""

[filetype]
# File type colors
rules = [
  # Code files
  { mime = "text/x-c", fg = "blue" },
  { mime = "text/x-c++", fg = "blue" },
  { mime = "text/x-python", fg = "yellow" },
  { mime = "text/x-shellscript", fg = "green" },
  
  # Config files
  { mime = "application/json", fg = "yellow" },
  { mime = "application/x-yaml", fg = "yellow" },
  { mime = "text/x-toml", fg = "yellow" },
  
  # Images
  { mime = "image/*", fg = "magenta" },
  
  # Videos
  { mime = "video/*", fg = "magenta" },
  
  # Archives
  { mime = "application/*zip", fg = "red" },
  { mime = "application/x-tar", fg = "red" },
]
EOF
fi

# 14. yazi keymap config

info "Configuring yazi keymaps"
if [ ! -f ~/.config/yazi/keymap.toml ]; then
    cat > ~/.config/yazi/keymap.toml << 'EOF'

# keymap.toml - Custom keybindings

[manager]
# Navigation
keymap = [
  # Basic movement (default)
  { on = [ "k" ], run = "arrow -1", desc = "Move up" },
  { on = [ "j" ], run = "arrow 1", desc = "Move down" },
  { on = [ "h" ], run = "leave", desc = "Go back" },
  { on = [ "l" ], run = "enter", desc = "Enter directory" },
  
  # Quick navigation
  { on = [ "g", "h" ], run = "cd ~", desc = "Go home" },
  { on = [ "g", "c" ], run = "cd ~/.config", desc = "Go to config" },
  { on = [ "g", "p" ], run = "cd ~/projects", desc = "Go to projects" },
  { on = [ "g", "s" ], run = "cd ~/scripts", desc = "Go to scripts" },
  { on = [ "g", "d" ], run = "cd ~/Downloads", desc = "Go to downloads" },
  
  # File operations
  { on = [ "o" ], run = "open", desc = "Open file" },
  { on = [ "O" ], run = "open --interactive", desc = "Open with..." },
  { on = [ "<Enter>" ], run = "open", desc = "Open file" },
  
  # Selection
  { on = [ "<Space>" ], run = "select --state=none", desc = "Toggle selection" },
  { on = [ "v" ], run = "visual_mode", desc = "Enter visual mode" },
  { on = [ "V" ], run = "visual_mode --unset", desc = "Exit visual mode" },
  
  # Copy, move, delete
  { on = [ "y" ], run = "yank", desc = "Copy" },
  { on = [ "x" ], run = "yank --cut", desc = "Cut" },
  { on = [ "p" ], run = "paste", desc = "Paste" },
  { on = [ "P" ], run = "paste --force", desc = "Paste (overwrite)" },
  { on = [ "d" ], run = "remove", desc = "Delete" },
  { on = [ "D" ], run = "remove --permanently", desc = "Delete permanently" },
  
  # Create
  { on = [ "a" ], run = "create", desc = "Create file/dir" },
  { on = [ "r" ], run = "rename", desc = "Rename" },
  
  # Search and filter
  { on = [ "/" ], run = "find", desc = "Find" },
  { on = [ "n" ], run = "find_arrow", desc = "Next match" },
  { on = [ "N" ], run = "find_arrow --previous", desc = "Previous match" },
  
  # Sorting
  { on = [ "," ], run = "sort modified --dir-first", desc = "Sort by modified" },
  { on = [ "." ], run = "sort alphabetical --dir-first", desc = "Sort by name" },
  { on = [ ";" ], run = "sort size --dir-first", desc = "Sort by size" },
  
  # Toggle hidden files
  { on = [ "z", "h" ], run = "hidden toggle", desc = "Toggle hidden" },
  
  # Help
  { on = [ "?" ], run = "help", desc = "Show help" },
  
  # Quit
  { on = [ "q" ], run = "quit", desc = "Quit" },
  { on = [ "<Esc>" ], run = "escape", desc = "Cancel" },
]
EOF
fi

# 15. Neovim config
info "Installing Neovim configuration..."
if [ ! -d ~/.config/nvim ]; then
    git clone https://github.com/rjros/kickstart.nvim.git ~/.config/nvim
else
    warn "Neovim config already exists, skipping"
fi

# 16. Set zsh as default shell
info "Setting zsh as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    info "Please log out and log back in for shell change to take effect"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}Installation Complete!${NC}"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. IMPORTANT: Set terminal font to 'JetBrainsMono Nerd Font'"
echo "   - Open terminal settings"
echo "   - Change font to: JetBrainsMono Nerd Font"
echo "   - Close and reopen terminal"
echo ""
echo "2. Log out and log back in (for zsh default shell)"
echo ""
echo "3. Open Neovim and wait for plugins to install:"
echo "   nvim"
echo ""
echo "4. Install LSP servers in Neovim:"
echo "   :Mason"
echo "   Install: clangd, pyright, lua_ls, markdownlint-cli2,stylua"
echo ""
echo "5. Test keybindings:"
echo "   Space + e    → yazi"
echo "   Space + lg   → lazygit"
echo "   Space + sf   → search files"
echo ""
echo "Happy coding! 🚀"
