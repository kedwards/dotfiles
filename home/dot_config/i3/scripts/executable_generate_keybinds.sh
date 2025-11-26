#!/usr/bin/env bash

I3_CONFIG="$HOME/.config/i3/config"
OUT="$HOME/.config/i3/rofi/keybinds.txt"

declare -A ICONS=(
    ["terminal"]=""
    ["exec alacritty"]=""
    ["exec kitty"]=""
    ["exec wezterm"]=""
    ["exec rofi"]="󰀲"
    ["restart"]="󰜉"
    ["exit"]=""
    ["kill"]="󰅖"
    ["fullscreen"]=""
    ["move workspace"]=""
)

# Clear output file
echo -n "" > "$OUT"

# Extract bindsym lines
grep -E '^\s*bindsym\s+' "$I3_CONFIG" | while read -r line; do
    # Extract key combo
    key=$(echo "$line" | sed -E 's/^\s*bindsym\s+([^\s]+).*/\1/')

    # Extract command after bindsym key
    cmd=$(echo "$line" | sed -E 's/^\s*bindsym\s+[^\s]+\s+(.*?)(\s+#.*|$)/\1/')

    # Extract description if present in comment
    desc=$(echo "$line" | sed -nE 's/.*#\s*(.*)/\1/p')

    # If no description, make command label nicer
    if [ -z "$desc" ]; then
        desc="$cmd"
        desc=$(echo "$desc" | sed 's/exec\s*--no-startup-id\s*//')
        desc=$(echo "$desc" | sed 's/exec\s*//')
        desc=$(echo "$desc" | sed 's/-/_/g')
    fi

    # Guess icon
    icon=""
    for match in "${!ICONS[@]}"; do
        if [[ "$cmd" == *"$match"* ]]; then
            icon="${ICONS[$match]}"
            break
        fi
    done

    printf "%s;%s;%s\n" "$key" "$desc" "$icon" >> "$OUT"
done

echo "Generated: $OUT"

