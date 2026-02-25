#!/usr/bin/env bash
set -euo pipefail

CHEZMOI_LOG="${1:-}"

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

# Compare actual applied files with expected list
if [ -n "$CHEZMOI_LOG" ] && [ -f "$CHEZMOI_LOG" ]; then
  echo "Checking applied files match expected list..."

  # Parse chezmoi verbose output to extract managed files
  # chezmoi uses diff format: "diff --git a/.cargo b/.cargo"
  # Extract the second path (after "b/") and convert to absolute paths
  ACTUAL_FILES=$(grep -E '^diff --git a/ b/' "$CHEZMOI_LOG" | \
    sed -E "s|^diff --git a/.* b/(.*)|$HOME/\1|" | \
    sort -u)

  # Build expected files list with proper separators for comparison
  EXPECTED=""
  for file in "${FILES[@]}"; do
    EXPECTED="${EXPECTED}${file}"$'\n'
  done

  # Check for unexpected files
  UNEXPECTED_FILES=""
  while IFS= read -r actual_file; do
    # Skip empty lines
    [ -z "$actual_file" ] && continue

    # Check if this file is in our expected list
    is_expected=false
    for expected_file in "${FILES[@]}"; do
      if [ "$actual_file" = "$expected_file" ]; then
        is_expected=true
        break
      fi
    done

    if [ "$is_expected" = false ]; then
      UNEXPECTED_FILES="${UNEXPECTED_FILES}  - ${actual_file}"$'\n'
    fi
  done <<< "$ACTUAL_FILES"

  if [ -n "$UNEXPECTED_FILES" ]; then
    echo "Error: Found unexpected files applied by chezmoi (not in expected list):"
    echo "$UNEXPECTED_FILES"
    echo "This may indicate .chezmoiignore is missing entries."
    echo "Please update .chezmoiignore or add the file to the expected list in verify-dotfiles.sh"
    exit 1
  fi

  # Check for missing files (files in expected list but not applied)
  APPLIED_FILES=""
  while IFS= read -r actual_file; do
    [ -z "$actual_file" ] && continue
    APPLIED_FILES="${APPLIED_FILES}${actual_file}"$'\n'
  done <<< "$ACTUAL_FILES"

  MISSING_FILES=""
  for file in "${FILES[@]}"; do
    if ! echo "$APPLIED_FILES" | grep -qx "$file"; then
      MISSING_FILES="${MISSING_FILES}  - ${file}"$'\n'
    fi
  done

  if [ -n "$MISSING_FILES" ]; then
    echo "Error: Expected files were not applied by chezmoi:"
    echo "$MISSING_FILES"
    exit 1
  fi

  echo "  Applied files match expected list"
else
  echo "Warning: No chezmoi log provided, skipping applied files comparison"
fi

echo "==> All verifications passed"
