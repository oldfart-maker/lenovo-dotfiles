#!/usr/bin/env bash

# This a basic install script for my emacs environment. It is not
# intended to be fully automated but to do enought installation
# and have enough documented that any issues can be easily resolved.
#
# Post script:
# 1) Install mu from aur
# 2) install feh
# 3) Make sure to fix .bashrc or .zshrc below
# 4) Restore Maildir
# 5) Restore .mbsyncrc
# 6) Install msmtp isync (sudo pacman -S msmtp isync)
# 7) Restore ~/.config/msmtp/*
# 8) Rebuild mail index:
# 8.1) mu init --maildir=~/Maildir --my-address=mkburns61@yahoo.com
# 8.2) mu index
##################################################################
# Modify .zshrc for remote connections to access this device
# Early exit for ssh connections using emacs TRAMP
# if [[ "$TERM" == "dumb" && -n "$SSH_CONNECTION" ]]; then
#    exec /bin/bash --noprofile --norc
#    return
# fi
##################################################################

set -euo pipefail

echo "==> Creating required directories..."
mkdir -p \
  ~/.config/emacs-common \
  ~/.config/systemd/user \
  ~/.config/emacs-prod/modules \
  ~/.config/msmtp \
  ~/.local/bin 

echo "==> Cloning emacs_babel_config..."
git clone https://github.com/oldfart-maker/emacs_babel_config.git /tmp/emacs_babel_config

echo "==> Running Emacs to tangle config..."
emacs --batch --chdir=/tmp/emacs_babel_config \
  --eval="(progn
             (require 'org)
             (org-babel-tangle-file \"emacs_config.org\"))"

echo "==> Copying tangled modules to emacs-prod..."
cp -r /tmp/emacs_babel_config/modules/* ~/.config/emacs-prod/modules/

echo "==> Sparse-checkout of emacs-common from lenovo-dotfiles..."
rm -rf /tmp/lenovo-dotfiles
git clone --filter=blob:none --no-checkout https://github.com/oldfart-maker/lenovo-dotfiles.git /tmp/lenovo-dotfiles
git -C /tmp/lenovo-dotfiles sparse-checkout init --cone
git -C /tmp/lenovo-dotfiles sparse-checkout set .config/emacs-common
git -C /tmp/lenovo-dotfiles checkout

echo "==> Copying emacs-common files..."
cp /tmp/lenovo-dotfiles/.config/emacs-common/emacs-prod.service ~/.config/systemd/user/
cp /tmp/lenovo-dotfiles/.config/emacs-common/emacs-profile ~/.local/bin/
cp /tmp/lenovo-dotfiles/.config/emacs-common/emacsr ~/.local/bin/
cp /tmp/lenovo-dotfiles/.config/emacs-common/init.el ~/.config/emacs-prod
cp /tmp/lenovo-dotfiles/.config/emacs-common/api-keys.el ~/.config/emacs-common
cp /tmp/lenovo-dotfiles/.config/emacs-common/bbdb ~/.config/emacs-common
sudo cp /tmp/lenovo-dotfiles/.config/emacs-common/emacs-prod.desktop /usr/share/applications/

echo "==> Registering and starting emacs-prod.service..."
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now emacs-prod.service

echo "✅ Emacs environment setup complete!"
