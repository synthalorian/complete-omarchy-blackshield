#!/usr/bin/env bash
# Complete Omarchy Blackshield — theme install.
# Does not install Omarchy. Does not touch the bootloader.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

die() { echo "error: $*" >&2; exit 1; }
say() { echo "== $*"; }

if [[ ! -d /usr/share/omarchy ]] && ! command -v omarchy-theme-set >/dev/null; then
  die "Omarchy is not installed. Install Omarchy first: https://omarchy.org/"
fi

STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/.config/omarchy-backup-$STAMP"
mkdir -p "$BACKUP"
say "backup -> $BACKUP"

backup_file() {
  local path="$1"
  if [[ -e "$path" || -L "$path" ]]; then
    mkdir -p "$BACKUP/$(dirname "${path#"$HOME/"}")"
    cp -a "$path" "$BACKUP/${path#"$HOME/"}"
  fi
}

say "theme"
dest="$HOME/.config/omarchy/themes/blackshield"
backup_file "$dest"
rm -rf "$dest"
mkdir -p "$dest"
cp -a "$ROOT/themes/blackshield/." "$dest/"
rm -rf "$dest/.git"
mkdir -p "$HOME/.config/omarchy/backgrounds/blackshield"
cp -a "$ROOT/themes/blackshield/backgrounds/." "$HOME/.config/omarchy/backgrounds/blackshield/"
# The forged Papirus blood icon theme is not in this repo.
if [[ ! -f "$HOME/.local/share/icons/Blackshield-Icons/index.theme" ]]; then
  printf '%s\n' "Yaru-red" > "$dest/icons.theme"
fi

say "cursor"
mkdir -p "$HOME/.local/share/icons" "$HOME/.icons"
backup_file "$HOME/.local/share/icons/Blackshield"
rm -rf "$HOME/.local/share/icons/Blackshield"
cp -a "$ROOT/cursors/Blackshield" "$HOME/.local/share/icons/Blackshield"
ln -sfn "$HOME/.local/share/icons/Blackshield" "$HOME/.icons/Blackshield"

say "shell"
mkdir -p "$HOME/.config/omarchy/bar/modules" "$HOME/.config/omarchy/plugins" \
  "$HOME/.config/omarchy/bin" "$HOME/.config/omarchy/branding"
backup_file "$HOME/.config/omarchy/shell.json"
cp -a "$ROOT/shell/shell.json" "$HOME/.config/omarchy/shell.json"
cp -a "$ROOT/shell/bar/modules/." "$HOME/.config/omarchy/bar/modules/"
for p in synth.background synth.blackshield-edge synth.clock synth.workspaces; do
  backup_file "$HOME/.config/omarchy/plugins/$p"
  rm -rf "$HOME/.config/omarchy/plugins/$p"
  cp -a "$ROOT/shell/plugins/$p" "$HOME/.config/omarchy/plugins/$p"
done
cp -a "$ROOT/shell/bin/." "$HOME/.config/omarchy/bin/"
chmod 755 "$HOME/.config/omarchy/bin/"*
cp -a "$ROOT/shell/branding/." "$HOME/.config/omarchy/branding/"

say "fonts"
font_dest="$HOME/.local/share/fonts/blackshield"
mkdir -p "$font_dest" "$HOME/.config/fontconfig/conf.d" "$HOME/.local/share/fonts/nerd-symbols"
backup_file "$HOME/.config/fontconfig/fonts.conf"
cp -a "$ROOT/fonts/." "$font_dest/"
# Keep the Nerd face on the path fontconfig names.
if [[ -d "$ROOT/fonts/nerd-symbols" ]]; then
  cp -a "$ROOT/fonts/nerd-symbols/." "$HOME/.local/share/fonts/nerd-symbols/"
fi
cp -a "$ROOT/config/fontconfig/fonts.conf" "$HOME/.config/fontconfig/fonts.conf"
if command -v fc-cache >/dev/null; then
  fc-cache -f "$font_dest" "$HOME/.local/share/fonts/nerd-symbols" || true
fi
echo "Do not run 'omarchy font set'. It rewrites fonts.conf and blanks the bar."

say "terminals and prompt"
mkdir -p "$HOME/.config/alacritty" "$HOME/.config/foot" "$HOME/.config/kitty" "$HOME/.config/ghostty"
backup_file "$HOME/.config/alacritty/alacritty.toml"
backup_file "$HOME/.config/foot/foot.ini"
backup_file "$HOME/.config/kitty/kitty.conf"
backup_file "$HOME/.config/ghostty/config"
backup_file "$HOME/.config/starship.toml"
cp -a "$ROOT/config/terminals/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
cp -a "$ROOT/config/terminals/foot.ini" "$HOME/.config/foot/foot.ini"
cp -a "$ROOT/config/terminals/kitty.conf" "$HOME/.config/kitty/kitty.conf"
cp -a "$ROOT/config/terminals/ghostty.conf" "$HOME/.config/ghostty/config"
cp -a "$ROOT/config/starship.toml" "$HOME/.config/starship.toml"

say "gtk cursor"
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
backup_file "$HOME/.config/gtk-3.0/settings.ini"
backup_file "$HOME/.config/gtk-4.0/settings.ini"
cp -a "$ROOT/config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
cp -a "$ROOT/config/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
if [[ -f "$HOME/.local/share/icons/Blackshield-Icons/index.theme" ]]; then
  sed -i 's/^gtk-icon-theme-name=.*/gtk-icon-theme-name=Blackshield-Icons/' \
    "$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
fi

say "hypr cursor block"
lf="$HOME/.config/hypr/looknfeel.lua"
mkdir -p "$HOME/.config/hypr"
if [[ -f "$lf" ]]; then
  backup_file "$lf"
fi
if [[ ! -f "$lf" ]]; then
  cp "$ROOT/config/hypr/looknfeel.lua" "$lf"
elif ! grep -q "blackshield:begin" "$lf"; then
  printf '\n' >> "$lf"
  cat "$ROOT/config/hypr/looknfeel.lua" >> "$lf"
else
  python3 - "$lf" "$ROOT/config/hypr/looknfeel.lua" << 'PY'
import pathlib, sys
dest, src = map(pathlib.Path, sys.argv[1:3])
block = src.read_text().strip("\n")
text = dest.read_text()
start = text.find("-- blackshield:begin")
end = text.find("-- blackshield:end")
if start < 0 or end < 0 or end < start:
    dest.write_text(text.rstrip() + "\n\n" + block + "\n")
else:
    end += len("-- blackshield:end")
    dest.write_text(text[:start] + block + text[end:])
PY
fi

if command -v omarchy-theme-set >/dev/null; then
  say "apply blackshield"
  omarchy-theme-set blackshield
else
  echo "omarchy-theme-set is not on PATH. Theme files are in place."
fi

camp="$(find "$dest/backgrounds" -name '01-*' -print -quit || true)"
bgdir="$HOME/.local/state/omarchy/current"
if [[ -n "$camp" && -d "$bgdir" ]]; then
  ln -sfn "$camp" "$bgdir/background"
fi

if command -v hyprctl >/dev/null && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  hyprctl reload || echo "hyprctl reload failed — check hyprctl configerrors"
fi

echo
echo "Blackshield is installed."
echo "Backup: $BACKUP"
echo "This does not change monitors, the bootloader, or your login screen."
