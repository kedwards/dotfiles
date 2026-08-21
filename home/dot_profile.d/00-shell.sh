set -o vi
bind 'set show-mode-in-prompt on'
bind 'set vi-cmd-mode-string "\1\e[31m\2\1\e[0m\2 "'
bind 'set vi-ins-mode-string "\1\e[32m\2\1\e[0m\2 "'

export EDITOR=nvim

SHELL_TYPE="bash"
export SHELL_TYPE