__load_docker_tools() {
	source "$HOME/.local/bin/docker-tools"
	unset -f __load_docker_tools
}

alias dpp='__load_docker_tools; pull_push_image'
alias l='ls -laF'

up() {
	local count="${1:-1}"
	local path=""

	# Validate input is a positive integer
	if ! [[ "$count" =~ ^[0-9]+$ ]] || [ "$count" -lt 1 ]; then
		echo "Usage: up <positive-number>" >&2
		return 1
	fi

	for ((i = 0; i < count; i++)); do
		path+="../"
	done

	cd "$path" || return
}

alias awsl='aws --endpoint-url http://localhost:4566 --profile floci'

if command -v docker &>/dev/null; then
	# Container Analysis
	alias dive="docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive"

	# Container Management
	# Stop All containers
	dsa() {
		local containers
		mapfile -t containers < <(docker ps -a -q 2>/dev/null)
		if ((${#containers[@]})); then docker stop "${containers[@]}"; else echo "No containers to stop"; fi
	}
	# Remove All containers
	dra() {
		local containers
		mapfile -t containers < <(docker ps -a -q 2>/dev/null)
		if ((${#containers[@]})); then docker rm "${containers[@]}"; else echo "No containers to remove"; fi
	}

	# Image Management
	# Remove Dangling images
	drd() {
		local imgs
		mapfile -t imgs < <(docker images -f "dangling=true" -q 2>/dev/null)
		if ((${#imgs[@]})); then docker rmi -f "${imgs[@]}"; else echo "No dangling images to remove"; fi
	}
	# Remove Images
	dri() {
		local imgs
		mapfile -t imgs < <(docker images -q 2>/dev/null)
		if ((${#imgs[@]})); then docker rmi "${imgs[@]}"; else echo "No images to remove"; fi
	}

	# Container Information
	# Docker IP address
	dip() {
		if [[ $# -ne 1 ]]; then
			echo "Usage: dip <container_name_or_id>" >&2
			return 1
		fi
		docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$1"
	}
fi
