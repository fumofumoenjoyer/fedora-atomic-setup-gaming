#!/bin/bash

cd

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

rpm-ostree install zsh

sudo rpm-ostree apply-live

rpm-ostree install distrobox fastfetch

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

chsh

cd





