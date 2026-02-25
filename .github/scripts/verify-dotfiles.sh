#!/usr/bin/env bash
set -euo pipefail

CHEZMOI_LOG="${1:-}"

echo "==> Verifying dotfiles setup..."

echo "Checking chezmoi status..."
if [ -n "$(chezmoi status 2>/dev/null | grep -v '^$')" ]; then
  echo "Error: chezmoi status shows pending changes"
  chezmoi status
  exit 1
fi
echo "  Status clean"

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

if [ -n "$CHEZMOI_LOG" ] && [ -f "$CHEZMOI_LOG" ]; then
  echo "Checking applied files match expected list..."

  UNEXPECTED_FILES=""
  MISSING_FILES=""

  mapfile -t APPLIED_ARRAY < <(
    awk '
      /^diff --git a/ { diff_line = $0; next }
      /^new file mode 1[0-9][0-9][0-9][0-9]/ && diff_line != "" {
        match(diff_line, / b\/([^ ]+)/, m)
        print ENVIRON["HOME"] "/" m[1]
        diff_line = ""
      }
    ' "$CHEZMOI_LOG" | sort -u
  )

  for actual_file in "${APPLIED_ARRAY[@]}"; do
    [ -z "$actual_file" ] && continue

    is_expected=false
    for expected_file in "${FILES[@]}"; do
      if [ "$actual_file" = "$expected_file" ]; then
        is_expected=true
        break
      fi
    done

    if [ "$is_expected" = true ]; then
      echo "  ✓ $actual_file"
    else
      echo "  ✗ $actual_file (unexpected)"
      UNEXPECTED_FILES="${UNEXPECTED_FILES}  - ${actual_file}"$'\n'
    fi
  done

  for file in "${FILES[@]}"; do
    is_found=false
    for applied_file in "${APPLIED_ARRAY[@]}"; do
      if [ "$file" = "$applied_file" ]; then
        is_found=true
        break
      fi
    done

    if [ "$is_found" = false ]; then
      echo "  ✗ $file (missing)"
      MISSING_FILES="${MISSING_FILES}  - ${file}"$'\n'
    fi
  done

  if [ -n "$UNEXPECTED_FILES" ]; then
    echo "Error: Found unexpected files applied by chezmoi (not in expected list):"
    echo "$UNEXPECTED_FILES"
    echo "This may indicate .chezmoiignore is missing entries."
    echo "Please update .chezmoiignore or add the file to the expected list in verify-dotfiles.sh"
    exit 1
  fi

  if [ -n "$MISSING_FILES" ]; then
    echo "Error: Expected files were not applied by chezmoi:"
    echo "$MISSING_FILES"
    exit 1
  fi

  echo "  Applied files match expected list (${#APPLIED_ARRAY[@]} files)"
else
  echo "Warning: No chezmoi log provided, skipping applied files comparison"
fi

echo "==> All verifications passed"
