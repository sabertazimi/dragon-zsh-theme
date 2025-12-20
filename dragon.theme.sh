#!/usr/bin/env bash
# vim: ft=bash ts=2 sw=2 sts=2
#
# dragon theme: a fork of the agnoster theme
#
# @see https://github.com/sabertazimi/dragon-zsh-theme
# @see https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt-1
source "$OSH/themes/agnoster/agnoster.theme.sh"

function prompt_context {
  prompt_segment black default "\t"
}

function prompt_dir {
  prompt_segment blue black "\W"
}

