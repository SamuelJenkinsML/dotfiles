#!/usr/bin/env bash

# Dotfiles installation script
# Usage: ./install.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Logging functions
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS or Linux
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    else
        error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    info "Detected OS: $OS"
}

# Backup existing dotfiles
backup_dotfiles() {
    info "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    local files=(
        "$HOME/.zshrc"
        "$HOME/.tmux.conf"
        "$HOME/.config/kitty"
        "$HOME/.config/nvim"
    )
    
    if [[ "$OS" == "macos" ]]; then
        files+=("$HOME/Library/Application Support/Code/User/settings.json")
        files+=("$HOME/Library/Application Support/Code/User/keybindings.json")
    else
        files+=("$HOME/.config/Code/User/settings.json")
        files+=("$HOME/.config/Code/User/keybindings.json")
    fi
    
    for file in "${files[@]}"; do
        if [[ -e "$file" ]] && [[ ! -L "$file" ]]; then
            info "Backing up: $file"
            mkdir -p "$(dirname "$BACKUP_DIR/${file#$HOME/}")"
            cp -r "$file" "$BACKUP_DIR/${file#$HOME/}"
        fi
    done
    
    success "Backup completed"
}

# Install Homebrew (macOS only)
install_homebrew() {
    if [[ "$OS" == "macos" ]]; then
        if ! command -v brew &> /dev/null; then
            info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            success "Homebrew installed"
        else
            success "Homebrew already installed"
        fi
    fi
}

# Install dependencies
install_dependencies() {
    info "Installing dependencies..."
    
    if [[ "$OS" == "macos" ]]; then
        brew install tmux zsh kitty neovim git
    else
        sudo apt update
        sudo apt install -y tmux zsh git curl wget build-essential
        
        # Install Kitty
        if ! command -v kitty &> /dev/null; then
            info "Installing Kitty..."
            curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        fi
        
        # Install Neovim
        if ! command -v nvim &> /dev/null; then
            info "Installing Neovim..."
            wget -q https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
            sudo tar -xzf nvim-linux64.tar.gz -C /opt
            sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
            rm nvim-linux64.tar.gz
        fi
    fi
    
    success "Dependencies installed"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        success "Oh My Zsh installed"
    else
        success "Oh My Zsh already installed"
    fi
}

# Install Powerlevel10k
install_powerlevel10k() {
    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [[ ! -d "$p10k_dir" ]]; then
        info "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
        success "Powerlevel10k installed"
    else
        success "Powerlevel10k already installed"
    fi
}

# Install TPM (Tmux Plugin Manager)
install_tpm() {
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        info "Installing TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        success "TPM installed"
    else
        success "TPM already installed"
    fi
}

# Create symlinks
create_symlinks() {
    info "Creating symlinks..."
    
    # Zsh
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    success "Linked .zshrc"
    
    # Tmux
    ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
    success "Linked .tmux.conf"
    
    # Kitty
    mkdir -p "$HOME/.config/kitty"
    ln -sf "$DOTFILES_DIR/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
    success "Linked kitty.conf"
    
    # Neovim
    if [[ -e "$HOME/.config/nvim" ]] && [[ ! -L "$HOME/.config/nvim" ]]; then
        rm -rf "$HOME/.config/nvim"
    fi
    ln -sf "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
    success "Linked nvim config"
    
    # VS Code
    if [[ "$OS" == "macos" ]]; then
        local vscode_dir="$HOME/Library/Application Support/Code/User"
        mkdir -p "$vscode_dir"
        ln -sf "$DOTFILES_DIR/.config/vscode/settings.json" "$vscode_dir/settings.json"
        ln -sf "$DOTFILES_DIR/.config/vscode/keybindings.json" "$vscode_dir/keybindings.json"
    else
        local vscode_dir="$HOME/.config/Code/User"
        mkdir -p "$vscode_dir"
        ln -sf "$DOTFILES_DIR/.config/vscode/settings.json" "$vscode_dir/settings.json"
        ln -sf "$DOTFILES_DIR/.config/vscode/keybindings.json" "$vscode_dir/keybindings.json"
    fi
    success "Linked VS Code settings"
    
    success "All symlinks created"
}

# Set Zsh as default shell
set_zsh_default() {
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        info "Setting Zsh as default shell..."
        chsh -s "$(which zsh)"
        success "Zsh set as default shell"
    else
        success "Zsh is already the default shell"
    fi
}

# Main installation
main() {
    echo ""
    echo "╔════════════════════════════════════╗"
    echo "║   Dotfiles Installation Script    ║"
    echo "╚════════════════════════════════════╝"
    echo ""
    
    detect_os
    backup_dotfiles
    install_homebrew
    install_dependencies
    install_oh_my_zsh
    install_powerlevel10k
    install_tpm
    create_symlinks
    set_zsh_default
    
    echo ""
    echo "╔════════════════════════════════════╗"
    echo "║     Installation Complete! 🎉     ║"
    echo "╚════════════════════════════════════╝"
    echo ""
    info "Backup created at: $BACKUP_DIR"
    echo ""
    warning "Next steps:"
    echo "  1. Restart your terminal or run: exec zsh"
    echo "  2. Launch tmux and press Ctrl+Space + I to install tmux plugins"
    echo "  3. Run 'p10k configure' to customize your prompt"
    echo "  4. Launch nvim - plugins will auto-install"
    echo "  5. Install VS Code extensions (see README.md)"
    echo ""
}

# Run main installation
main
