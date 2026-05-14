#!/usr/bin/env bash
# Claude Code status line
# Receives JSON on stdin from Claude Code
# Format: Model: <name> | Ctx: <remaining>% | Cost: $<n>

input=$(cat)

# Model display name
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
model_id=$(echo "$input" | jq -r '.model.id // ""')

# Context window - remaining percentage (pre-calculated by Claude Code)
ctx_remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Cumulative session totals for cost calculation
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')

# Cost estimation (USD) based on model pricing (per-million-token rates)
# Pricing tiers: input / output per 1M tokens
case "$model_id" in
*claude-opus-4* | *claude-opus-4-5*)
  price_in="15.0"
  price_out="75.0"
  ;;
*claude-sonnet-4* | *claude-sonnet-4-5* | *claude-sonnet-4-6*)
  price_in="3.0"
  price_out="15.0"
  ;;
*claude-haiku-3-5* | *claude-haiku-3-6*)
  price_in="0.8"
  price_out="4.0"
  ;;
*claude-haiku*)
  price_in="0.25"
  price_out="1.25"
  ;;
*claude-3-5-sonnet* | *claude-3-7-sonnet*)
  price_in="3.0"
  price_out="15.0"
  ;;
*claude-3-opus*)
  price_in="15.0"
  price_out="75.0"
  ;;
*)
  price_in="3.0"
  price_out="15.0"
  ;;
esac

cost=$(awk -v ti="$total_in" -v to="$total_out" \
  -v pi="$price_in" -v po="$price_out" \
  'BEGIN { printf "%.2f", (ti * pi / 1000000) + (to * po / 1000000) }')

# ANSI color codes
RESET='\033[0m'
SEP='\033[0m' # default color for separators

# Section colors (vibrant)
C_MODEL='\033[1;36m' # bold cyan  - Model section
C_CTX='\033[1;32m'   # bold green - Ctx section
C_COST='\033[1;31m'  # bold red   - Cost section

# Build Ctx field: show percentage if available, otherwise omit
if [ -n "$ctx_remaining" ]; then
  ctx_str=$(printf "%.0f" "$ctx_remaining")
  printf "${C_MODEL}Model: %s${RESET} ${SEP}|${RESET} ${C_CTX}Ctx: %s%%${RESET} ${SEP}|${RESET} ${C_COST}Cost: \$%s${RESET}\n" \
    "$model" "$ctx_str" "$cost"
else
  printf "${C_MODEL}Model: %s${RESET} ${SEP}|${RESET} ${C_COST}Cost: \$%s${RESET}\n" \
    "$model" "$cost"
fi
