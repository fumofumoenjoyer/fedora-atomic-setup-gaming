#!/bin/bash
#
# Bazzite-Arch Gaming Environment Setup Script
#
# This script automates the creation of a gaming-focused Distrobox container
# using the bazzite-arch image. It then installs the binary version of lsfg-vk
# from the AUR and exports key applications (Steam, Bottles, LSFG-VK UI) to
# your host system's application menu.
#

# --- Configuration ---
# You can change the container name here if you like.
CONTAINER_NAME="game-box"
CONTAINER_IMAGE="ghcr.io/ublue-os/bazzite-arch:latest"

# --- Script Start ---
set -e # Exit immediately if a command exits with a non-zero status.

echo "🚀 Starting Bazzite Gaming Environment Setup..."

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

# 3. Install lsfg-vk-bin and export applications
echo "⚙️ Entering container to install lsfg-vk and export applications..."

# We execute a series of commands inside the container.
# - Update the yay database and install lsfg-vk-bin without asking for confirmation.
# - Export the desktop entries for the applications to the host.
distrobox enter "${CONTAINER_NAME}" -- <<EOF
echo "Installing gaming-apps from the AUR..."
paru -Syyu --noconfirm goverlay yay mangohud lsfg-vk-bin steam proton-ge-custom-bin heroic-games-launcher-bin bottles wine giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader cups samba dosbox winetricks
echo "Exporting applications to host..."
distrobox-export --app steam
distrobox-export --app bottles
distrobox-export --app heroic
distrobox-export --app lsfg-vk-ui
EOF

echo "✅ Applications installed and exported."
echo ""
echo "🎉 Setup complete!"
echo "You should now find icons for 'Steam', 'heroic', and 'LSFG VK UI' in your host system's application menu."
echo "Remember to install 'Lossless Scaling' from Steam inside the '${CONTAINER_NAME}' container to use lsfg-vk."
