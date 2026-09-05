#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Example: Swap GNOME Desktop with COSMIC Desktop
###############################################################################
# This example demonstrates replacing the GNOME desktop environment with
# System76's COSMIC desktop from their COPR repository.
#
# COSMIC is a new desktop environment built in Rust by System76.
# https://github.com/pop-os/cosmic-epoch
#
# To use this script:
# 1. Rename to remove .example extension: mv 30-cosmic-desktop.sh.example 30-cosmic-desktop.sh
# 2. Build - scripts run in numerical order automatically
#
# WARNING: This removes GNOME and replaces it with COSMIC. Only use this if
# you want COSMIC as your desktop environment instead of GNOME.
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

echo "::group:: Remove GNOME Desktop"

# Remove GNOME Shell and related packages
dnf5 remove -y \
	gnome-bluetooth \
	gnome-color-manager \
	gnome-control-center \
	gnome-control-center-filesystem \
	gnome-epub-thumbnailer \
	gonme-icon-theme \
	gnome-online-accounts \
	gnome-rounded-blurs \
	gnome-shell \
	gnome-shell-extension* \
	gnome-shell-common \
	gnome-software \
	gnome-terminal \
	gnome-tour \
	gnome-tweaks \
	gnome-user-docs \
	nautilus \
	xdg-portal-gnome \
	gdm

echo "GNOME desktop removed"
echo "::endgroup::"

echo "::group:: Install COSMIC Desktop"

# Install COSMIC desktop from System76's COPR
# Using isolated pattern to prevent COPR from persisting
copr_install_isolated "ryanabx/cosmic-epoch" \
	cosmic-applets \
	cosmic-calculator \
	cosmic-ext-applet-emoji-selector \
	cosmic-ext-applet-examine \
	cosmic-ext-camera \
	cosmic-ext-tweaks \
	cosmic-comp \
	cosmic-edit \
	cosmic-ext-tweaks \
	cosmic-files \
	cosmic-greeter \
	cosmic-launcher \
	cosmic-monitor \
	cosmic-panel \
	cosmic-player \
	cosmic-session \
	cosmic-settings \
	cosmic-store \
	cosmic-term \
	cosmic-wallpapers \
	cosmic-workspaces

# fedora-release-cosmic.noarch	Base package for Fedora COSMIC specific default configurations
# fedora-release-cosmic-atomic.noarch	Base package for Fedora COSMIC Atomic specific default configurations
# fedora-release-identity-cosmic.noarch	Package providing the identity for Fedora COSMIC Spin
# fedora-release-identity-cosmic-atomic.noarch	Package providing the identity for Fedora COSMIC Atomic

echo "COSMIC desktop installed successfully"
echo "::endgroup::"

echo "::group:: Configure Display Manager"

# Enable cosmic-greeter (COSMIC's display manager)
systemctl enable cosmic-greeter

# Set COSMIC as default session
mkdir -p /etc/X11/sessions
cat >/etc/X11/sessions/cosmic.desktop <<'COSMICDESKTOP'
[Desktop Entry]
Name=COSMIC
Comment=COSMIC Desktop Environment
Exec=cosmic-session
Type=Application
DesktopNames=COSMIC
COSMICDESKTOP

echo "Display manager configured"
echo "::endgroup::"

echo "::group:: Install Additional Utilities"

# Install additional utilities that work well with COSMIC
dnf5 install -y \
	kitty \
	flatpak \
	xdg-desktop-portal-cosmic

echo "Additional utilities installed"
echo "::endgroup::"

echo "COSMIC desktop installation complete!"
echo "After booting, select 'COSMIC' session at the login screen"
