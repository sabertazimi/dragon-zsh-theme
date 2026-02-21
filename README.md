# dotfiles

[![Author](https://img.shields.io/badge/author-sabertaz-lightgrey?style=for-the-badge)](https://github.com/sabertazimi)
[![LICENSE](https://img.shields.io/github/license/sabertazimi/dotfiles?style=for-the-badge)](https://raw.githubusercontent.com/sabertazimi/dotfiles/main/LICENSE)
[![Code Size](https://img.shields.io/github/languages/code-size/sabertazimi/dotfiles?logo=visualstudiocode&style=for-the-badge)](https://github.com/sabertazimi/dotfiles)

Hackable personal dotfiles.

## Terminal Themes

### Zsh Theme

A minimalistic zsh prompt theme for git users.

Features:

- Pretty prefix prompt signature
- Pretty color
- Current directory
- Time stamp
- Git prompt info
- Git status info

Installation:

```bash
# Clone this repo
git clone https://github.com/sabertazimi/dotfiles.git ~/dotfiles

# Install theme to custom directory
mkdir -p ~/.oh-my-zsh/custom/themes
cp ~/dotfiles/themes/zsh/dragon.zsh-theme ~/.oh-my-zsh/custom/themes/

# Set theme in ~/.zshrc
sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="dragon"/' ~/.zshrc

# Reload shell
source ~/.zshrc
```

![Zsh Theme](./screenshots/zsh.png)

### Bash Theme

A minimalistic bash prompt theme for git-bash on Windows.

Installation:

```bash
# Clone this repo
git clone https://github.com/sabertazimi/dotfiles.git ~/dotfiles

# Install theme to custom directory
mkdir -p ~/.oh-my-bash/custom/themes/dragon
cp ~/dotfiles/themes/bash/dragon.theme.sh ~/.oh-my-bash/custom/themes/dragon/

# Set theme in ~/.bashrc
sed -i 's/^OSH_THEME=".*"/OSH_THEME="dragon"/' ~/.bashrc

# Reload shell
source ~/.bashrc
```

![Bash Theme](./screenshots/bash.png)

## License

MIT License Copyright (c) [Sabertaz](https://github.com/sabertazimi)

## Contact

[![GitHub](https://img.shields.io/badge/-GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/sabertazimi)
[![Email](https://img.shields.io/badge/-Gmail-ea4335?style=for-the-badge&logo=gmail&logoColor=white)](mailto:sabertazimi@gmail.com)
[![X](https://img.shields.io/badge/-X.com-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/sabertazimi)
