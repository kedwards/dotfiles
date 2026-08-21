export PROFILE_CACHE_DIR="${PROFILE_CACHE_DIR:-$HOME/.cache}"
export PYTHON_VENV_DIR="${PYTHON_VENV_DIR:-$HOME/.venv}"
export TMUX_PLUGIN_DIR="${TMUX_PLUGIN_DIR:-$HOME/.tmux/plugins}"

eval "$($HOME/.local/bin/mise activate bash)"