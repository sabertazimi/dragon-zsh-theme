#!/usr/bin/env bash
set -euo pipefail

echo "==> Verifying dotfiles setup..."

# Check idempotency - should have no changes after initial apply
echo "Checking idempotency..."
if ! chezmoi apply --dry-run 2>&1 | grep -q "no changes"; then
  echo "Error: chezmoi apply would make changes, not idempotent"
  chezmoi apply --dry-run
  exit 1
fi
echo "  Idempotency OK"

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
  "$HOME/.zshrc"
  "$HOME/.config/matugen"
)

for file in "${FILES[@]}"; do
  if [ ! -e "$file" ]; then
    echo "Error: $file not found"
    exit 1
  fi
  echo "  ✓ $file"
done

echo "==> All verifications passed"
