__load_docker_tools() {
  source "$HOME/.local/bin/docker-tools"
  unset -f __load_docker_tools
}

__load_git_tools() {
  source "$HOME/.local/bin/git-tools"
  unset -f __load_git_tools
}

[ -f "${BMA_HOME:-$HOME/.bash-my-aws}/aliases" ] &&
  source "${BMA_HOME:-$HOME/.bash-my-aws}/aliases"

alias l='ls -laF'
alias dpp='__load_docker_tools; pull_push_image'
alias clone='__load_git_tools; clone_repository'
alias wt='__load_git_tools; worktree'
alias myip='net-tools myip'

alias t='tmux-tools'


# Docker
if command -v docker &>/dev/null; then
  # Container Analysis
  alias dive="docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive"

  # Container Management
  # Stop All containers
  alias dsa='_dsa() { local containers=$(docker ps -a -q 2>/dev/null); [[ -n "$containers" ]] && docker stop $containers || echo "No containers to stop"; }; _dsa'
  # Remove All containers
  alias dra='_dra() { local containers=$(docker ps -a -q 2>/dev/null); [[ -n "$containers" ]] && docker rm $containers || echo "No containers to remove"; }; _dra'

  # Image Management
  # Remove Dangling images
  alias drd='_drd() { local imgs=$(docker images -f "dangling=true" -q 2>/dev/null); [[ -n "$imgs" ]] && docker rmi -f $imgs || echo "No dangling images to remove"; }; _drd'
  # Remove Images
  alias dri='_dri() { local imgs=$(docker images -q 2>/dev/null); [[ -n "$imgs" ]] && docker rmi $imgs || echo "No images to remove"; }; _dri'

  # Container Information
  # Docker IP address
  alias dip='_dip() { [[ $# -eq 1 ]] && docker inspect -f `{{"{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"}}` "$1" 2>/dev/null || echo "Usage: dip <container_name_or_id>"; }; _dip'
fi

{{- if or (eq .chezmoi.osRelease.id "arch") (eq .chezmoi.osRelease.id "endeavouros") }}

# pacman
if command -v pacman &>/dev/null; then
  # install package
  alias paci='sudo pacman -S'

  # Pacman Has Installed - what files where installed in a package
  alias pachi='sudo pacman -Ql'

  # search
  alias pacs='sudo pacman -Ss'

  # update
  alias pacu='sudo pacman -Syu'

  # remove package but not dependencies
  alias pacr='sudo pacman -R'

  # remove package with unused dependencies by other softwares
  alias pacrr='sudo pacman -Rs'

  # remove pacman cache
  alias pacrc='sudo pacman -Sc'
  alias pacc='sudo pacman -Sc'
  alias paccc='sudo pacman -Scc' # empty the whole cache
fi

# yay
if command -v yay &>/dev/null; then
  # install
  alias yayi='yay -S'

  # Yay Has Installed - what files where installed in a package
  alias yayhi='yay -Ql'

  # search
  alias yays='yay -Ss'

  # update
  alias yayu='yay -Syu'

  # remove package but not dependencies
  alias yayr='yay -R'

  # remove package with unused dependencies by other softwares
  alias yayrr='yay -Rs'

  # remove yay's cache
  alias yayrc='yay -Sc'
  alias yayls="yay -Qe"
fi
{{- end }}

