# Color
BLUE="%{$fg_bold[blue]%}"
GREEN="%{$fg_bold[green]%}"
YELLOW="%{$fg_bold[yellow]%}"
CYAN="%{$fg_bold[cyan]%}"
RED="%{$fg_bold[red]%}"
MAGENTA="%{$fg_bold[magenta]%}"
WHITE="%{$fg_bold[white]%}"
RESET="%{$reset_color%}"

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX="$YELLOW $CYAN"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" $RED✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" $GREEN✔"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_ADDED="$GREEN+"
ZSH_THEME_GIT_PROMPT_MODIFIED="$BLUE!"
ZSH_THEME_GIT_PROMPT_DELETED="$RED-"
ZSH_THEME_GIT_PROMPT_RENAMED="$MAGENTA>"
ZSH_THEME_GIT_PROMPT_UNMERGED="$YELLOW#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="$CYAN?"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" $WHITE^"

# Directory info
# local current_dir='${PWD/#$HOME/~}'

# Machine name
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo $HOST
}

function get_right_prompt() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [[ -z $(git_prompt_info) ]]; then
            echo -n "$BLUEdetached-head$RESET $(git_prompt_status)"
        else
            echo -n "$(git_prompt_info) $(git_prompt_status)|$BLUE$(git_prompt_short_sha)$RESET"
        fi
    else
        echo -n "$RESET"
    fi
}

if [[ "$USER" == "root" ]]; then
    PROMPT="$RED⬡ $RED%n$RESET@$GREEN$(box_name): $YELLOW%c
$CYAN→ $RESET"
else
    PROMPT="$GREEN⬢ $BLUE%n$RESET@$GREEN$(box_name): $YELLOW%c
$CYAN→ $RESET"
fi

RPROMPT='$(get_right_prompt)'

