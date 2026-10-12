#!/usr/bin/env bash
# Remove the Blackshield user theme. Does not touch the bootloader.
set -euo pipefail

say() { echo "== $*"; }

say "theme and cursor"
rm -rf "$HOME/.config/omarchy/themes/blackshield"
rm -rf "$HOME/.config/omarchy/backgrounds/blackshield"
rm -rf "$HOME/.local/share/icons/Blackshield"
rm -f "$HOME/.icons/Blackshield"
rm -rf "$HOME/.local/share/fonts/blackshield"

say "shell pieces this install added"
rm -f "$HOME/.config/omarchy/bar/modules/blackshield-crest.qml"
rm -f "$HOME/.config/omarchy/bar/modules/blackshield-gpu.qml"
rm -f "$HOME/.config/omarchy/bar/modules/blackshield-rule.qml"
rm -rf "$HOME/.config/omarchy/plugins/synth.background"
rm -rf "$HOME/.config/omarchy/plugins/synth.blackshield-edge"
rm -rf "$HOME/.config/omarchy/plugins/synth.clock"
rm -rf "$HOME/.config/omarchy/plugins/synth.workspaces"
rm -f "$HOME/.config/omarchy/bin/omarchy-screensaver"
rm -f "$HOME/.config/omarchy/bin/omarchy-show-done"
rm -f "$HOME/.config/omarchy/bin/omarchy-show-logo"
rm -f "$HOME/.config/omarchy/branding/about.txt"
rm -f "$HOME/.config/omarchy/branding/screensaver.txt"

if command -v omarchy-theme-set >/dev/null; then
  if [[ -d /usr/share/omarchy/themes/catppuccin ]]; then
    omarchy-theme-set catppuccin || true
  else
    echo "Pick another theme with: omarchy theme set <name>"
  fi
fi

echo
echo "Blackshield files removed."
echo "shell.json, fontconfig, terminals, and looknfeel.lua were not deleted."
echo "Restore those from the newest ~/.config/omarchy-backup-* if you want the previous desk."
