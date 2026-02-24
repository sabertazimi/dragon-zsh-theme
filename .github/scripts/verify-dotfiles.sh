#!/usr/bin/env bash
set -euo pipefail

echo "==> Verifying dotfiles setup..."

# Verify chezmoi status is clean
echo "Checking chezmoi status..."
if [ -n "$(chezmoi status 2>/dev/null | grep -v '^$')" ]; then
  echo "Error: chezmoi status shows pending changes"
  chezmoi status
  exit 1
fi
echo "  Status clean"

# Check key dotfiles exist
echo "Checking managed files..."
FILES=(
  "$HOME/.cargo/config.toml"
  "$HOME/.config/environment.d/90-dms.conf"
  "$HOME/.config/fcitx5/conf/classicui.conf"
  "$HOME/.config/ghostty/config"
  "$HOME/.config/matugen/config.toml"
  "$HOME/.config/matugen/templates/starship.toml"
  "$HOME/.config/mpv/mpv.conf"
  "$HOME/.config/satty/config.toml"
  "$HOME/.gitmsg.md"
  "$HOME/.local/share/fcitx5/rime/default.custom.yaml"
  "$HOME/.ripgreprc"
  "$HOME/.zshrc"
)

for file in "${FILES[@]}"; do
  if [ ! -e "$file" ]; then
    echo "Error: $file not found"
    exit 1
  fi
  echo "  ✓ $file"
done

echo "==> All verifications passed"
