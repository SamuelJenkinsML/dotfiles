# VS Code Configuration

Custom VS Code settings and keybindings.

## Installation

### macOS/Linux

```bash
# Link settings
ln -sf ~/.config/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json

# Link keybindings
ln -sf ~/.config/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
```

### Recommended Extensions

- **GitHub Copilot** - AI pair programmer
- **Prettier** - Code formatter (`esbenp.prettier-vscode`)
- **Black Formatter** - Python formatter (`ms-python.black-formatter`)
- **Python** - Python IntelliSense (`ms-python.python`)
- **ESLint** - JavaScript linter (`dbaeumer.vscode-eslint`)
- **GitLens** - Enhanced Git capabilities (`eamodio.gitlens`)
- **Live Share** - Real-time collaboration (`ms-vsliveshare.vsliveshare`)

## Settings Overview

### Editor
- JetBrains Mono font with ligatures
- Format on save enabled
- Bracket pair colorization
- Sticky scroll for better context

### Terminal
- Integrated terminal with zsh
- Smooth cursor and scrolling
- 10,000 line scrollback

### Files
- Auto-save on focus change
- Trim trailing whitespace
- Insert final newline

### Git
- Auto-fetch enabled
- Smart commit enabled
- No confirmation for sync

## Custom Keybindings

- `Cmd+P` - Quick file open
- `Cmd+Shift+P` - Command palette
- `Ctrl+\`` - Toggle terminal
- `Cmd+\\` - Split editor
- `Alt+Up/Down` - Move lines
- `Cmd+Shift+D` - Duplicate line
- `Cmd+D` - Multi-cursor selection
