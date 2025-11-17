# Dotfiles

Personal configuration files for Unix-based systems (macOS/Linux).

## Contents

- **Zsh** - Shell configuration with Powerlevel10k prompt
- **Tmux** - Terminal multiplexer settings
- **Kitty** - GPU-based terminal emulator
- **Neovim** - LazyVim configuration
- **VS Code** - Editor settings and keybindings

## Quick Installation

Clone this repository and run the installation script:

```bash
git clone https://github.com/SamuelJenkinsML/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

The script will:
1. Backup existing configuration files
2. Create symlinks to the dotfiles
3. Install Homebrew (if not already installed on macOS)
4. Install required dependencies
5. Set up Oh My Zsh and Powerlevel10k

## Manual Installation

### Prerequisites

#### macOS
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install tmux zsh kitty neovim git
```

#### Linux (Ubuntu/Debian)
```bash
# Update package list
sudo apt update

# Install dependencies
sudo apt install -y tmux zsh git curl wget build-essential

# Install Kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Install Neovim (latest)
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo tar -xzf nvim-linux64.tar.gz -C /opt
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
```

### Zsh Setup

```bash
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Symlink zshrc
ln -sf ~/.dotfiles/.zshrc ~/.zshrc

# Reload shell
source ~/.zshrc
```

### Tmux Setup

```bash
# Symlink tmux config
ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf

# Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Reload tmux config (if already running)
tmux source ~/.tmux.conf
# Press prefix + I (default: Ctrl+Space + I) to install plugins
```

### Kitty Setup

```bash
# Create config directory if it doesn't exist
mkdir -p ~/.config/kitty

# Symlink kitty config
ln -sf ~/.dotfiles/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf
```

### Neovim Setup

```bash
# Symlink neovim config
ln -sf ~/.dotfiles/.config/nvim ~/.config/nvim

# Launch Neovim (plugins will auto-install via Lazy.nvim)
nvim
```

### VS Code Setup

```bash
# macOS
ln -sf ~/.dotfiles/.config/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -sf ~/.dotfiles/.config/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json

# Linux
ln -sf ~/.dotfiles/.config/vscode/settings.json ~/.config/Code/User/settings.json
ln -sf ~/.dotfiles/.config/vscode/keybindings.json ~/.config/Code/User/keybindings.json
```

#### Recommended VS Code Extensions

Install via command line:

```bash
code --install-extension GitHub.copilot
code --install-extension esbenp.prettier-vscode
code --install-extension ms-python.black-formatter
code --install-extension ms-python.python
code --install-extension dbaeumer.vscode-eslint
code --install-extension eamodio.gitlens
```

## Updating

To update your dotfiles with the latest changes:

```bash
cd ~/.dotfiles
git pull origin main
```

Symlinks will automatically reflect the changes. You may need to reload your shell or restart applications.

## Customization

### Zsh

Edit `~/.dotfiles/.zshrc` to add your own aliases, functions, and environment variables.

### Tmux

Edit `~/.dotfiles/.tmux.conf` for custom keybindings and settings. Reload with:
```bash
tmux source ~/.tmux.conf
```

### Powerlevel10k

Configure the prompt:
```bash
p10k configure
```

## Backup

The installation script automatically creates backups in `~/.dotfiles-backup-[timestamp]`. To restore:

```bash
cp -r ~/.dotfiles-backup-[timestamp]/.zshrc ~/.zshrc
# Repeat for other files as needed
```

## Uninstall

```bash
# Remove symlinks
rm ~/.zshrc ~/.tmux.conf
rm -rf ~/.config/kitty ~/.config/nvim
rm ~/Library/Application\ Support/Code/User/settings.json
rm ~/Library/Application\ Support/Code/User/keybindings.json

# Restore from backup
cp -r ~/.dotfiles-backup-[timestamp]/* ~/
```

## License

Feel free to use these dotfiles as you wish.
