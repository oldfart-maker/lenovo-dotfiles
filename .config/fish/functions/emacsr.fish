#!/usr/bin/env fish

echo "fish..."
echo "Restarting emacs.service..."
systemctl --user restart emacs.service
echo "Restarting emacs-prod.service..."
systemctl --user restart emacs-prod.service
echo "Restarting emacs-dev.service..."
systemctl --user restart emacs-dev.service
echo "✅ All Emacs services restarted."
