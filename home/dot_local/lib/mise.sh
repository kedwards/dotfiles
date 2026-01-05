mise_info() {
  local tool="$1"
  mise which "$tool" 2>/dev/null || return 1
}
