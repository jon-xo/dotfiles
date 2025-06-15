# Dotfiles

A collection of development environment configuration files for Linux/WSL2, featuring Zsh, Oh My Zsh, Neovim, and various development tools.

## Features

- Automated setup using Makefile
- Zsh configuration with Oh My Zsh
- Custom terminal prompt using Starship
- Neovim configuration with multiple plugins
- WSL2-specific configurations
- Git aliases and functions
- Development utilities (fzf, exa, bat)

## Installation

1. Clone this repository:
```bash
git clone <repository-url> ~/bin/dotfiles
cd ~/bin/dotfiles
```

2. Run the automated setup:
```bash
make
```

Or install specific components:
```bash
make install-sys-deps      # Install system dependencies
make install-zsh-omz      # Install Zsh and Oh My Zsh
make configure-zsh        # Configure Zsh
make install-nvm         # Install Node Version Manager
make install-pyenv       # Install Python Version Manager
make install-dev-utils   # Install additional development utilities
```

## Included Configurations

### Zsh
- Oh My Zsh with custom plugins:
  - git-open
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - common-aliases

### Neovim
- Plugin management with vim-plug
- Nord color theme
- File browsing with NERDTree
- Fuzzy finding with FZF
- Code completion with CoC
- TypeScript/JavaScript support
- Various quality-of-life improvements

### Terminal
- Starship prompt configuration
- FiraCode Nerd Font
- Custom aliases and functions
- WSL2-specific optimizations

### Development Tools
- Node.js version management (NVM)
- Python version management (pyenv)
- Git configuration and aliases
- Development utilities (fzf, exa, bat)

## Backup System

The repository includes a backup system (`backup_plus_copy.sh`) that automatically creates dated backups of existing configuration files before replacing them.

## Requirements

- Linux/WSL2
- Git
- Make

## License

This project is open-source. Feel free to use and modify as needed.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.