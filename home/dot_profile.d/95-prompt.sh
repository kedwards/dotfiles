#!/usr/bin/env bash
[[ $- == *i* ]] || return
command -v starship >/dev/null && eval "$(starship init bash)"
