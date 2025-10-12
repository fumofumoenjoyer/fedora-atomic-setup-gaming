#!/bin/bash
#
# Archlinux development environment setup script
#

# --- Configuration ---
# You can change the container name here if you like.
CONTAINER_NAME="dev-box"
CONTAINER_IMAGE="quay.io/toolbx/arch-toolbox:latest"

# --- Script Start ---
set -e # Exit immediately if a command exits with a non-zero status.

echo "🚀 Starting Archlinux Development Environment Setup..."

# 1. Check if distrobox is installed
if ! command -v distrobox &> /dev/null; then
    echo "❌ Error: distrobox could not be found."
    echo "Please install distrobox on your host system before running this script."
    exit 1
fi

echo "✅ Distrobox is installed."

# 2. Check if the container already exists
if distrobox list | grep -q " ${CONTAINER_NAME} "; then
    echo "ℹ️ Container '${CONTAINER_NAME}' already exists. Skipping creation."
else
    echo "📦 Creating the '${CONTAINER_NAME}' container using image: ${CONTAINER_IMAGE}..."
    echo "This may take a few minutes depending on your internet connection."
    # We add --init to enable systemd inside the container, which is good practice.
    # We also add --nvidia for automatic NVIDIA GPU integration. If you have an AMD or Intel GPU,
    # this flag will be safely ignored.
    distrobox create --name "${CONTAINER_NAME}" --image "${CONTAINER_IMAGE}" --init --nvidia
    echo "✅ Container created successfully."
fi

# 3. Install dev tools and export applications
echo "⚙️ Entering container to install tools and export applications..."

# We execute a series of commands inside the container.
# - Update the  database and install lsfg-vk-bin without asking for confirmation.
# - Export the desktop entries for the applications to the host.
distrobox enter "${CONTAINER_NAME}" -- <<EOF
echo "Installing dev packages..."
sudo pacman -S --noconfirm --needed base-devel git
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd
yay -Syyu --noconfirm npm zsh bash podman spyder typescript eslint python-pip gdb gcc make maven jdk-openjdk kotlin clang llvm lld lldb libc++ cython libclc polly rustup visual-studio-code-bin 
rustup update
rustup default nightly
rustup target add wasm32-unknown-unknown
echo "Exporting applications to host..."
distrobox-export --app code
EOF

echo "✅ Applications installed and exported."
echo ""
echo "🎉 Setup complete!"
