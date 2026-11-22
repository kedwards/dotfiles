export PROFILE_CACHE_DIR="${PROFILE_CACHE_DIR:-$HOME/.cache}"
export PYTHON_VENV_DIR="${PYTHON_VENV_DIR:-$HOME/.venv}"
command -v mise >/dev/null && eval "$(mise activate bash)"
