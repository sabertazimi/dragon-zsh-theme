#!/usr/bin/env bash
# vim: ft=bash ts=2 sw=2 sts=2
#
# dragon theme: a fork of the agnoster theme
#
# @see https://github.com/sabertazimi/dragon-zsh-theme
# @see https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt-1
# shellcheck disable=SC1091
source "$OSH/themes/agnoster/agnoster.theme.sh"

function prompt_context {
  local user
  user=$(whoami)

  if [[ $user != "$DEFAULT_USER" || -n $SSH_CLIENT ]]; then
    prompt_segment black default "$user@\h \t"
  else 
    prompt_segment black default "\t"
  fi

}

function prompt_dir {
  prompt_segment blue black "\W"
}

function prompt_status {
  local symbols REPLY
  symbols=()
  if ((RETVAL != 0)); then
    _omb_theme_agnoster_fg_color red
    _omb_theme_agnoster_ansi_single "$REPLY"
    symbols+=("${REPLY}✘")
  fi
  if ((UID == 0)); then
    _omb_theme_agnoster_fg_color yellow
    _omb_theme_agnoster_ansi_single "$REPLY"
    symbols+=("${REPLY}⚡")
  fi
  if compgen -j &>/dev/null; then
    _omb_theme_agnoster_fg_color cyan
    _omb_theme_agnoster_ansi_single "$REPLY"
    symbols+=("${REPLY}⬢")
  fi

  [[ ${symbols[*]} ]] && prompt_segment black default "${symbols[*]}"
}

