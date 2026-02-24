# AGENTS.md

Guidance to coding agents when working with code in this repository.

Hackable personal dotfiles managed with chezmoi.

## Structure

```plaintext
themes/           # Shell themes (zsh, bash)
screenshots/      # Previews
wallpapers/       # Wallpaper management scripts
dot_*/            # Managed dotfiles (public)
private_dot_*/    # Managed dotfiles (private)
```

## Chezmoi Conventions

- `dot_*` files are installed to `~/.*` (e.g., `dot_zshrc` → `~/.zshrc`)
- `private_dot_*` files are private (e.g., `dot_local/share/private_fcitx5/` -> `~/.local/share/fcitx5/`)
- Files under `dot_config/` install to `~/.config/`
- Files under `dot_local/` install to `~/.local/`

## Commit

Conventional commits: `chore:`, `feat:`, `fix:`, `docs:`.
