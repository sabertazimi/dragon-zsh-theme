# Color
BLUE="%{$fg_bold[blue]%}"
GREEN="%{$fg_bold[green]%}"
YELLOW="%{$fg_bold[yellow]%}"
CYAN="%{$fg_bold[cyan]%}"
RED="%{$fg_bold[red]%}"
RESET="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="$YELLOW $CYAN"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" $RED⦿"
ZSH_THEME_GIT_PROMPT_CLEAN=" $GREEN⦾"

# Directory info
# local current_dir='${PWD/#$HOME/~}'

# Machine name
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo $HOST
}

function get_right_prompt() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -n "$(git_prompt_info) |$BLUE$(git_prompt_short_sha)$RESET"
    else
        echo -n "$RESET"
    fi
}

PROMPT="$GREEN⬢  $BLUE%n$RESET@$GREEN$(box_name): $YELLOW%c $RESET"
if [[ "$USER" == "root" ]]; then
PROMPT="$GREEN#  $RED%n$RESET@$GREEN$(box_name): $YELLOW%c $RESET"
fi

RPROMPT='$(get_right_prompt)'
