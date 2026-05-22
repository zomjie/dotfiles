#!/usr/bin/env bash
# Display: folder  model  ████░░░░  45% context  |  in:1.5k out:3.2k
#
# Colors:
#   Folder: blue     Bar used: green
#   Model: cyan      Bar remaining: dim
#   Percentage: bright white
#   Input tokens: green    Output tokens: blue

set -euo pipefail

# ---- Helpers ----
format_tokens() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    echo "$n" | awk '{printf "%.1fM", $1/1000000}'
  elif [ "$n" -ge 1000 ]; then
    echo "$n" | awk '{printf "%.1fk", $1/1000}'
  else
    echo "$n"
  fi
}

# ---- Parse Input ----
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
folder=$(echo "$input" | jq -r '.workspace.current_dir // "unknown"' | sed 's|.*/||; s|^$|/|')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
tokens_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // "0"')
tokens_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // "0"')

# ---- ANSI color codes ----
R=$'\e[0m'      # Reset
BL=$'\e[34m'    # Blue
CY=$'\e[36m'    # Cyan
GN=$'\e[32m'    # Green
DI=$'\e[2m'     # Dim
BR=$'\e[97m'    # Bright white

# ---- No messages yet ----
if [ -z "$used" ]; then
  printf "${BL}%s${R}  ${CY}%s${R}  ${BR}0%%${R} context\n" "$folder" "$model"
  exit 0
fi

# ---- Clamp percentage ----
if [ "$(printf '%.0f' "$used")" -gt 100 ]; then
  used_int=100
elif [ "$(printf '%.0f' "$used")" -lt 0 ]; then
  used_int=0
else
  used_int=$(printf '%.0f' "$used")
fi

# ---- Build progress bar ----
bar_width=20
filled=$(( used_int * bar_width / 100 ))
empty=$(( bar_width - filled ))

bar=""
for ((i = 0; i < filled; i++)); do
  bar="${bar}█"
done
for ((i = 0; i < empty; i++)); do
  bar="${bar}░"
done

bar_colored="${GN}${bar:0:filled}${DI}${bar:filled:empty}${R}"

# ---- Token info ----
in_fmt=$(format_tokens "$tokens_in")
out_fmt=$(format_tokens "$tokens_out")

# ---- Output with fixed spacing ----
printf "${BL}%s${R}   [${CY}%s${R}]   %s ${BR}%s%%${R} context   ${BR}|${R}   ${GN}in:%s${R} ${BL}out:%s${R}\n" \
  "$folder" "$model" "$bar_colored" "$used_int" "$in_fmt" "$out_fmt"
