#!/bin/bash

cd

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

sudo tee /etc/yum.repos.d/vscodium.repo << EOF
[gitlab.com_paulcarroty_vscodium_repo]
name=download.vscodium.com
baseurl=https://download.vscodium.com/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
metadata_expire=1h
EOF

rpm-ostree install distrobox clang llvm java-latest-openjdk-devel gcc zsh codium

flatpak install flathub app.devsuite.Ptyxis
flatpak install flathub dev.vencord.Vesktop
flatpak install flathub com.stremio.Stremio
flatpak install flathub org.onlyoffice.desktopeditors
flatpak install flathub com.github.tchx84.Flatseal
flatpak install flathub com.ranfdev.DistroShelf
flatpak install flathub com.brave.Browser
flatpak install flathub org.qbittorrent.qBittorrent
flatpak install flathub com.protonvpn.www
flatpak install flathub io.podman_desktop.PodmanDesktop


cd

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh



