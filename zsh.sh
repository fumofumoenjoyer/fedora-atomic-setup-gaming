#!/bin/bash

# A script to automate the installation of Oh My Zsh and its plugins.

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Helper Functions ---
# Function to print messages
print_message() {
    echo "--------------------------------------------------"
    echo "$1"
    echo "--------------------------------------------------"
}

# --- Main Script ---

# 1. Check for Dependencies (git, zsh, curl)
print_message "Checking for dependencies..."
command -v git >/dev/null 2>&1 || { echo >&2 "Git is not installed. Please install it first."; exit 1; }
command -v zsh >/dev/null 2>&1 || { echo >&2 "Zsh is not installed. Please install it first."; exit 1; }
command -v curl >/dev/null 2>&1 || { echo >&2 "Curl is not installed. Please install it first."; exit 1; }
print_message "All dependencies are satisfied."

# 2. Install Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    print_message "Oh My Zsh is already installed. Skipping installation."
else
    print_message "Installing Oh My Zsh..."
    # The installer will back up an existing .zshrc, but we will overwrite it later.
    # Using the --unattended flag to run non-interactively.
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. Define the custom plugins directory
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# 4. Clone Plugins
print_message "Cloning custom plugins..."

# zsh-autosuggestions
if [ -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions already exists. Skipping clone."
else
    echo "Cloning zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
    echo "zsh-syntax-highlighting already exists. Skipping clone."
else
    echo "Cloning zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
fi

# 5. Create the .zshrc configuration file
print_message "Creating .zshrc configuration..."
cat << 'EOF' > "$HOME/.zshrc"
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- "robbyrussell" is the default.
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# List of plugins that have been enabled.
# Add custom plugins on this line.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Source the main Oh My Zsh script.
source "$ZSH/oh-my-zsh.sh"

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"
# export LANG=en_US.UTF-8

EOF

# 6. Set Zsh as the default shell (optional, but recommended)
if [ "$SHELL" != "$(which zsh)" ]; then
    print_message "Changing default shell to Zsh. You may be asked for your password."
    # The `chsh` command requires user interaction, so we check if the script is running in a tty
    if tty -s; then
        chsh -s "$(which zsh)"
    else
        echo "Cannot change shell in a non-interactive environment."
        echo "Please run 'chsh -s $(which zsh)' manually."
    fi
fi

print_message "Installation complete!"
echo "Please log out and log back in, or start a new terminal session to use Zsh with the new configuration."
