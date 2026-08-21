command -v aws_completer >/dev/null && complete -C "$(command -v aws_completer)" aws

[ -f /etc/bash_completion ] && source /etc/bash_completion

[ -f "$HOME/.local/share/bash-completion/completions/docker" ] &&
  source "$HOME/.local/share/bash-completion/completions/docker"

[ -f "$HOME/.local/share/bash-completion/completions/git-completion.bash" ] &&
  source "$HOME/.local/share/bash-completion/completions/git-completion.bash"

[ -f "${BMA_HOME:-$HOME/.bash-my-aws}/bash_completion.sh" ] &&
  source "${BMA_HOME:-$HOME/.bash-my-aws}/bash_completion.sh"
