# dotfiles

[![Author](https://img.shields.io/badge/author-sabertaz-lightgrey?style=for-the-badge)](https://github.com/sabertazimi)
[![LICENSE](https://img.shields.io/github/license/sabertazimi/dotfiles?style=for-the-badge)](https://raw.githubusercontent.com/sabertazimi/dotfiles/main/LICENSE)
[![Code Size](https://img.shields.io/github/languages/code-size/sabertazimi/dotfiles?logo=visualstudiocode&style=for-the-badge)](https://github.com/sabertazimi/dotfiles)

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=archlinux&logoColor=white)](https://github.com/archlinux)
[![Niri](https://img.shields.io/badge/Niri-D55C44?style=for-the-badge&logo=niri&logoColor=white)](https://github.com/niri-wm/niri)
[![GNOME](https://img.shields.io/badge/GNOME-4A86CF?style=for-the-badge&logo=gnome&logoColor=white)](https://github.com/gnome)
[![KDE Plasma](https://img.shields.io/badge/KDE_Plasma-1D99F3?style=for-the-badge&logo=kdeplasma&logoColor=white)](https://github.com/kde)
[![Rust](https://img.shields.io/badge/Rust-000000?style=for-the-badge&logo=rust&logoColor=white)](https://github.com/rust-lang/rust)
[![Go](https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white)](https://github.com/golang/go)
[![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)](https://github.com/git/git)
[![Ghostty](https://img.shields.io/badge/Ghostty-3551F3?style=for-the-badge&logo=ghostty&logoColor=white)](https://github.com/ghostty-org/ghostty)
[![Zsh](https://img.shields.io/badge/Zsh-F15A24?style=for-the-badge&logo=zsh&logoColor=white)](https://github.com/ohmyzsh/ohmyzsh)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://github.com/ohmybash/oh-my-bash)
[![Starship](https://img.shields.io/badge/Starship-DD0B78?style=for-the-badge&logo=starship&logoColor=white)](https://github.com/starship/starship)
[![Rime](https://img.shields.io/badge/Rime-000000?style=for-the-badge&logo=rime&logoColor=white)](https://github.com/rime)
[![MPV](https://img.shields.io/badge/MPV-691F69?style=for-the-badge&logo=mpv&logoColor=white)](https://github.com/mpv-player/mpv)

Hackable personal dotfiles managed with [chezmoi](https://github.com/twpayne/chezmoi).

## Installation

Set up new machine:

```bash
sudo pacman -S chezmoi
chezmoi init --apply -v sabertazimi
```

```bash
git clone https://github.com/sabertazimi/dotfiles.git ~/dotfiles
```

See [Arch Linux setup guide](https://notes.tazimi.dev/programming/linux/arch)
for detailed system configuration.

## Configured Applications

### Development

- **Cargo**: Rust package manager with USTC mirror
- **Go**: Go environment config file
- **Ripgrep**: Enhanced search with web file types
- **Git**: Conventional commit templates

### Terminal & Shell

- **Zsh**: Oh My Zsh with modern CLI tools (mise, zoxide, fzf, starship)
- **Ghostty**: Modern Wayland terminal with dankcolors theme
- **Starship**: Dynamic prompt via matugen (Material You theming)

### Utilities

- **MPV**: Hardware-accelerated video player
- **Satty**: Wayland screenshot annotation tool
- **Fcitx5-Rime**: Chinese input with vertical candidates and dark theme

### Themes

- **Matugen**: Material You color scheme generator from wallpaper

## Wallpapers

Collection of wallpaper management scripts for Arch Linux:

- Interactive or command-line usage
- Automatic package installation
- Copies Arch Linux, GNOME, and KDE Plasma wallpapers
- `.jxl` to `.png` conversion for GNOME wallpapers
- Resolution priority selection for KDE Plasma wallpapers

```bash
# Make scripts executable
chmod +x ~/dotfiles/wallpapers/*.sh

# Run interactive menu
~/dotfiles/wallpapers/install.sh

# Or run specific script
~/dotfiles/wallpapers/install.sh all        # All wallpapers
~/dotfiles/wallpapers/install.sh archlinux  # Arch Linux wallpapers
~/dotfiles/wallpapers/install.sh gnome      # GNOME wallpapers
~/dotfiles/wallpapers/install.sh kde        # KDE Plasma wallpapers
```

Wallpapers are copied to `~/.local/share/wallpapers/`.

Requirements:

- ImageMagick (for GNOME `.jxl` conversion)
- `archlinux-wallpaper`
- `gnome-backgrounds`
- `plasma-workspace-wallpapers`

## Shell Themes

### Zsh Theme

Minimalistic zsh prompt theme for git users:

```bash
mkdir -p ~/.oh-my-zsh/custom/themes
cp ~/dotfiles/themes/zsh/dragon.zsh-theme ~/.oh-my-zsh/custom/themes/
sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="dragon"/' ~/.zshrc
source ~/.zshrc
```

![Zsh Theme](./.github/screenshots/zsh.png)

### Bash Theme

Minimalistic bash prompt theme for git-bash on Windows:

```bash
mkdir -p ~/.oh-my-bash/custom/themes/dragon
cp ~/dotfiles/themes/bash/dragon.theme.sh ~/.oh-my-bash/custom/themes/dragon/
sed -i 's/^OSH_THEME=".*"/OSH_THEME="dragon"/' ~/.bashrc
source ~/.bashrc
```

![Bash Theme](./.github/screenshots/bash.png)

## Caveats

Dotfiles not synced:

- `~/.gitconfig`, `~/.claude.json`, `~/.claude/settings.json` — contain keys and dynamically generated content
- `~/.config/niri/config.kdl`, `~/.config/DankMaterialShell/settings.json`, `~/.local/state/DankMaterialShell/session.json` — lengthy configuration files that are rarely modified, edited via `sed -i` instead of syncing to ensure new machines initialize to the corresponding version

## License

MIT License Copyright (c) [Sabertaz](https://github.com/sabertazimi)

## Contact

[![GitHub](https://img.shields.io/badge/-GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/sabertazimi)
[![Email](https://img.shields.io/badge/-Gmail-ea4335?style=for-the-badge&logo=gmail&logoColor=white)](mailto:sabertazimi@gmail.com)
[![X](https://img.shields.io/badge/-X.com-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/sabertazimi)
