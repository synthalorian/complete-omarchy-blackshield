# Complete Omarchy Blackshield

![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Omarchy%2FLinux-green.svg)

Iron, parchment, and blood. A complete Omarchy theme: matte black field, bone type, and a blood-red cross. No neon.

## Install

Omarchy has to be installed first. This does not install the OS, and it does not touch the bootloader.

```bash
curl -fsSL https://raw.githubusercontent.com/synthalorian/complete-omarchy-blackshield/main/install.sh | bash
```

Or clone and run:

```bash
git clone https://github.com/synthalorian/complete-omarchy-blackshield.git ~/.complete-omarchy-blackshield
~/.complete-omarchy-blackshield/install.sh
```

The installer copies the theme, cursor, bar, and fonts into your home directory. It backs up anything it overwrites to `~/.config/omarchy-backup-<timestamp>/`. It does not change your monitors.

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/synthalorian/complete-omarchy-blackshield/main/uninstall.sh | bash
```

That removes the theme, cursor, and bar pieces. It leaves `shell.json`, fontconfig, and terminal configs in place so a half-deleted bar does not come up blank. Restore those from the backup directory if you want the previous desk.

## What you get

- **Theme** `blackshield` — `colors.toml`, hand-authored shell chrome, lock plate, four backgrounds
- **Cursor** `Blackshield` — Phinger cursors, blood outline on black steel
- **Bar** — crest, blood rule, workspace plates, 12-hour clock, GPU module
- **Terminals** — Alacritty, Foot, Kitty, Ghostty, reading the applied theme
- **Prompt** — Starship in blood
- **Fonts** — Xanh Mono, Pirata One, EB Garamond, Symbols Nerd Font Mono

Palette:

- Iron `#101014`
- Parchment `#D8D3C8`
- Blood `#C1121F`
- Ember `#E5383B`
- Brass `#C9A227`
- Steel `#8F959C`

Backgrounds, in cycle order: camp, horse, contract, fight. Omarchy puts one plate on every screen.

## What this is not

- Not an Omarchy installer.
- Not a bootloader theme. Limine and Plymouth stay stock.
- Not a per-monitor layout. Your monitors file is left alone.
- Not the forged Papirus icon set. GTK icons fall back to `Yaru-red`, which ships with Omarchy. If you already have `Blackshield-Icons` installed, the installer keeps that name.
- Kelmscott Mono is the face on the author's desk. It has no redistribution license, so it is not in this repo. The install uses Xanh Mono instead.

Do not run `omarchy font set` after installing. That rewrites `fonts.conf` and the bar loses its icon glyphs.

## Third-party

See [NOTICES.md](NOTICES.md). Original theme files and scripts are Apache-2.0. Fonts are SIL OFL 1.1. The cursor is a recolor of Phinger Cursors (GPL-3.0). Symbols Nerd Font Mono is MIT.
