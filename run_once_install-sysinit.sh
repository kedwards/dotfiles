#!/bin/bash

MARKER="# BEGIN sysinit: load custom profile settings"
# Check if the snippet already exists
grep -Fq "$MARKER" ~/.bashrc && exit 0

# Append the snippet
cat <<'EOF' >> ~/.bashrc

# BEGIN sysinit: load custom profile settings"
if [ -d "$HOME/.profile.d" ]; then 
  for profile_file in "$HOME"/.profile.d/*; do
    [ -f "$profile_file" ] && [ -r "$profile_file" ] || continue
    source "$profile_file"
  done
  unset profile_file
fi
# END sysinit: load custom profile settings
EOF
