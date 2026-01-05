#!/usr/bin/env bash

path_add() {
  case ":$PATH:" in
  *":$1:"*) ;; # already in PATH
  *) PATH="$1:$PATH" ;;
  esac
}

path_add "$HOME/.local/bin"

[ -d "${BMA_HOME:-$HOME/.bash-my-aws}/bin" ] &&
  path_add "${BMA_HOME:-$HOME/.bash-my-aws}/bin"

export PATH
