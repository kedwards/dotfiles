path_add() {
	case ":$PATH:" in
	*":$1:"*) ;;
	*) PATH="$1:$PATH" ;;
	esac
}

path_add "$HOME/.local/bin"

export PATH
