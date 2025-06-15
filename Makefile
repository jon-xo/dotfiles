#!/usr/bin/make -f

# Makefile for setting up a common Zsh development environment on WSL2.
# This Makefile automates the installation and configuration of essential tools
# such as Zsh, Oh My Zsh, Node Version Manager (NVM), and pyenv for Python.

# Define ANSI color codes for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
CYAN := \033[0;36m
RED := \033[0;31m
BOLD := \033[1m
RESET := \033[0m

# Define variables for common paths or versions if needed
# NVM_DIR is the installation directory for NVM (Node Version Manager)
NVM_DIR := $(HOME)/.nvm
# PYENV_ROOT is the installation directory for pyenv (Python Version Manager)
PYENV_ROOT := $(HOME)/.pyenv

# Default target: Runs all main setup steps if no specific target is provided.
# This ensures a comprehensive setup process from start to finish.
.PHONY: all
all: install-sys-deps install-zsh-omz configure-zsh install-nvm install-pyenv install-dev-utils

# Help target: Provides information about available Makefile targets and their usage.
# This is useful for quickly understanding what the Makefile can do.
.PHONY: help
help:
	@echo "$(BOLD)$(CYAN)WSL2 Zsh Development Setup Makefile$(RESET)"
	@echo "$(CYAN)-------------------------------------------------------------------$(RESET)"
	@echo "This Makefile helps automate the setup of a common Zsh development"
	@echo "environment on WSL2, including Zsh, Oh My Zsh, NVM, and pyenv."
	@echo ""
	@echo "$(BOLD)Available Targets:$(RESET)"
	@echo "  $(BOLD)all$(RESET)                  : $(GREEN)Installs all dependencies and tools (default).$(RESET)"
	@echo "  $(BOLD)help$(RESET)                 : $(YELLOW)Displays this help message.$(RESET)"
	@echo "  $(BOLD)install-sys-deps$(RESET)  : Installs essential system-level build tools and utilities."
	@echo "  $(BOLD)install-zsh-omz$(RESET)  : Installs Zsh and the Oh My Zsh framework."
	@echo "  $(BOLD)configure-zsh$(RESET)        : Configures the .zshrc file with NVM and pyenv paths, and common aliases."
	@echo "  $(BOLD)install-nvm$(RESET)          : Installs Node Version Manager (NVM) for Node.js management."
	@echo "  $(BOLD)install-pyenv$(RESET)        : Installs pyenv for Python version management."
	@echo "  $(BOLD)install-dev-utils$(RESET): Installs additional useful development utilities like fzf, exa, and bat."
	@echo "  $(BOLD)clean$(RESET)                : Provides cleanup instructions (does not uninstall tools)."
	@echo ""
	@echo "$(CYAN)Usage: make [target]$(RESET)"
	@echo "$(CYAN)Example: make install-nvm$(RESET)"
	@echo "$(CYAN)-------------------------------------------------------------------$(RESET)"

# -----------------------------------------------------------------------------
# System Dependencies Installation
# -----------------------------------------------------------------------------

.PHONY: install-sys-deps
install-sys-deps:
	@echo "$(BOLD)$(YELLOW)>>> Installing essential system dependencies...$(RESET)"
	sudo apt update
	sudo apt install -y unzip build-essential curl git wget htop tmux neovim ca-certificates mosh
	@echo "$(GREEN)>>> System dependencies installed successfully.$(RESET)"

# -----------------------------------------------------------------------------
# Zsh and Oh My Zsh Setup
# -----------------------------------------------------------------------------

.PHONY: install-zsh-omz
install-zsh-omz:
	@echo "$(BOLD)$(YELLOW)>>> Installing Zsh...$(RESET)"
	sudo apt install -y zsh
	@echo "$(GREEN)Zsh installed.$(RESET)"
	@echo "$(BOLD)$(YELLOW)>>> Setting Zsh as default shell for $(USER) (you may need to log out and back in, or restart WSL).$(RESET)"
	chsh -s $(shell which zsh) $(USER)
	@echo "$(BOLD)$(YELLOW)>>> Installing Oh My Zsh...$(RESET)"
	# Check if Oh My Zsh is already installed before attempting installation.
	if [ ! -d "$(HOME)/.oh-my-zsh" ]; then \
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
		echo "$(GREEN)Oh My Zsh installed successfully.$(RESET)"; \
	else \
		echo "$(YELLOW)Oh My Zsh is already installed. Skipping installation.$(RESET)"; \
	fi
	@echo "$(BOLD)$(YELLOW)>>> Installing FiraCode Nerd Font...$(RESET)"
	@if [ ! -f ~/.local/share/fonts/FiraCode.zip ]; then \
		if ! command -v unzip &> /dev/null; then \
			echo "$(YELLOW)Unzip not found. Installing unzip...$(RESET)"; \
			sudo apt install -y unzip; \
		fi; \
		wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip; \
		FONT_DIR="~/.local/share/fonts" \
		echo "$(YELLOW)Font directory used: $(FONT_DIR)$(RESET)"; \
		cd $(FONT_DIR) \
		&& unzip FiraCode.zip \
		&& rm FiraCode.zip \
		&& fc-cache -fv; \
	else \
		echo "$(YELLOW)FiraCode Nerd Font is already installed. Skipping installation.$(RESET)"; \
	fi
	@echo "$(BOLD)$(YELLOW)>>> Installing Spaceship Zsh Theme...$(RESET)"
	@if [ ! -d "$(HOME)/.oh-my-zsh/custom/themes/spaceship-prompt" ]; then \
		git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$(HOME)/.oh-my-zsh/custom/themes/spaceship-prompt" --depth=1; \
		ln -s "$(HOME)/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "$(HOME)/.oh-my-zsh/custom/themes/spaceship.zsh-theme"; \
		echo "$(GREEN)Spaceship Zsh Theme installed successfully.$(RESET)"; \
	else \
		echo "$(YELLOW)Spaceship Zsh Theme is already installed. Skipping...$(RESET)"; \
	fi
	@if [ -f "$(HOME)/.oh-my-zsh/custom/plugins/git-open" ]; then \
		echo "$(YELLOW)git-open plugin is already installed. Skipping...$(RESET)"; \
	else \
		"git clone https://github.com/zsh-users/git-open.git" "$(HOME)/.oh-my-zsh/custom/plugins/git-open"; \
		echo "$(GREEN)Oh my zsh plugin: git-open successfully.$(RESET)"; \
	fi
	@if [ -f "$(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then \
		echo "$(YELLOW)zsh-autosuggestions plugin is already installed. Skipping...$(RESET)"; \
	else \
		git clone https://github.com/zsh-users/zsh-autosuggestions.git "$(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions"; \
		echo "$(GREEN)Oh my zsh plugin: zsh-autosuggestions successfully.$(RESET)"; \
	fi
	@if [ -f "$(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then \
		echo "$(YELLOW)zsh-syntax-highlighting plugin is already installed. Skipping...$(RESET)"; \
	else \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"; \
		echo "$(GREEN)Oh my zsh plugin: zsh-autosuggestions successfully.$(RESET)"; \
	fi
	@echo "$(GREEN)>>> Zsh and Oh My Zsh setup complete.$(RESET)"
	@echo "$(GREEN)FiraCode Nerd Font installed successfully.$(RESET)"

# -----------------------------------------------------------------------------
# Zsh Configuration (.zshrc)
# -----------------------------------------------------------------------------

.PHONY: configure-zsh
configure-zsh:
	@echo "$(BOLD)$(YELLOW)>>> Configuring .zshrc using backup_plus_copy.sh...$(RESET)"
	$(eval TEMP_ZSHRC=$(shell mktemp /tmp/temp_zshrc.XXXXXX))
	# Create a temporary .zshrc file with the desired content.
	# This temporary file will then be copied to the home directory.
	@echo "$(TEMP_ZSHRC)"
	@echo "$(BOLD)$(YELLOW)>>> Copying dot_zshrc to temp file: $(TEMP_ZSHRC)$(RESET)"
	cat ./dot_zshrc > $(TEMP_ZSHRC)
	
	# Use the copy_with_backup.sh script to copy the temporary .zshrc file to the home directory.
	# This ensures that any existing .zshrc is backed up automatically.
	# IMPORTANT: Ensure copy_with_backup.sh is in the same directory as this Makefile or in your PATH.
	@./backup_plus_copy.sh $(TEMP_ZSHRC) $(HOME) .zshrc
	# Clean up the temporary file after it has been copied.
	rm $(TEMP_ZSHRC)
	@echo "$(GREEN)>>> .zshrc configured successfully. Remember to open a new Zsh session or run: \\n'source ~/.zshrc'$(RESET)"

# -----------------------------------------------------------------------------
# Node.js with NVM Setup
# -----------------------------------------------------------------------------

.PHONY: install-nvm
install-nvm:
	@echo "$(BOLD)$(YELLOW)>>> Installing NVM (Node Version Manager)...$(RESET)"
	# Check if NVM is already installed to prevent re-installation.
	@if [ ! -d "$(NVM_DIR)" ]; then \
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash; \
		echo "$(GREEN)NVM installed. Please restart your shell or 'source ~/.zshrc' to use nvm.$(RESET)"; \
		echo "$(CYAN)After that, you can install Node.js like: nvm install --lts && nvm use --lts$(RESET)"; \
	else \
		echo "$(YELLOW)NVM is already installed. Skipping installation.$(RESET)"; \
	fi
	@echo "$(GREEN)>>> NVM setup complete.$(RESET)"

# -----------------------------------------------------------------------------
# Python with pyenv Setup
# -----------------------------------------------------------------------------

.PHONY: install-pyenv
install-pyenv:
	@echo "$(BOLD)$(YELLOW)>>> Installing pyenv...$(RESET)"
	# Install necessary build dependencies for pyenv to compile Python versions.
	sudo apt install -y make build-essential libssl-dev zlib1g-dev \
	libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
	libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
	# Check if pyenv is already installed to prevent re-installation.
	@if [ ! -d "$(PYENV_ROOT)" ]; then \
		git clone https://github.com/pyenv/pyenv.git "$(PYENV_ROOT)"; \
		echo "$(GREEN)pyenv installed. Please restart your shell or 'source ~/.zshrc' to use pyenv.$(RESET)"; \
		echo "$(CYAN)After that, you can install Python versions like: pyenv install 3.9.18 && pyenv global 3.9.18$(RESET)"; \
	else \
		echo "$(YELLOW)pyenv is already installed. Skipping installation.$(RESET)"; \
	fi
	@echo "$(GREEN)>>> pyenv setup complete.$(RESET)"

# -----------------------------------------------------------------------------
# Additional Development Utilities Installation
# -----------------------------------------------------------------------------

.PHONY: install-dev-utils
install-dev-utils:
	@echo "$(BOLD)$(YELLOW)>>> Installing additional development utilities (fzf, exa, bat)...$(RESET)"
	# fzf (fuzzy finder) installation
	@if [ ! -d "$(HOME)/.fzf" ]; then \
		git clone --depth 1 https://github.com/junegunn/fzf.git "$(HOME)/.fzf"; \
		"$(HOME)/.fzf/install" --all --no-bash --no-fish --key-bindings --completion --update-rc; \
		echo "$(GREEN)fzf installed.$(RESET)"; \
	else \
		echo "$(YELLOW)fzf is already installed. Skipping.$(RESET)"; \
	fi
	# eza (modern ls replacement) installation
	@if ! command -v eza &> /dev/null; then \
		sudo apt install -y eza; \
		echo "$(GREEN)eza installed.$(RESET)"; \
	else \
		echo "$(YELLOW)eza is already installed. Skipping.$(RESET)"; \
	fi
	# bat (cat replacement with syntax highlighting) installation
	@if ! command -v bat &> /dev/null; then \
		sudo apt install -y bat; \
		echo "$(GREEN)bat installed.$(RESET)"; \
	else \
		echo "$(YELLOW)bat is already installed. Skipping.$(RESET)"; \
	fi
	@echo "$(GREEN)>>> Additional utilities installed.$(RESET)"

# -----------------------------------------------------------------------------
# Cleanup Target
# -----------------------------------------------------------------------------

.PHONY: clean
clean:
	@echo "$(BOLD)$(YELLOW)>>> Cleaning up...$(RESET)"
	@echo "Removing temp files"
	rm -rfv /tmp/temp_zshrc.*
	@echo "To uninstall tools like Oh My Zsh, NVM, or pyenv, you need to follow their respective uninstallation guides."
	@echo "$(GREEN)>>> Cleanup complete.$(RESET)"
