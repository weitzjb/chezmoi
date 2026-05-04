#!/usr/bin/env bash
# Claude Code status line — model, directory, token usage, context usage, rate limits
# Located at ~/.claude/statusline-command.sh

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
dir=$(basename "$cwd")

used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Build context segment only when data is available
if [ -n "$used" ] && [ -n "$remaining" ]; then
  used_int=$(printf '%.0f' "$used")
  remaining_int=$(printf '%.0f' "$remaining")

  # Pick a colour: green < 50 %, yellow 50-79 %, red >= 80 %
  if [ "$used_int" -ge 80 ]; then
    color='\033[0;31m'   # red
  elif [ "$used_int" -ge 50 ]; then
    color='\033[0;33m'   # yellow
  else
    color='\033[0;32m'   # green
  fi
  reset='\033[0m'

  ctx_segment=$(printf "${color}ctx: %d%% used (%d%% left)${reset}" "$used_int" "$remaining_int")
else
  ctx_segment="ctx: --"
fi

# Build cumulative session token segment
# total_input_tokens and total_output_tokens are cumulative across the session
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')

if [ -n "$total_in" ] && [ -n "$total_out" ]; then
  total_tok=$(( total_in + total_out ))
  if [ "$total_tok" -ge 1000000 ]; then
    tok_label=$(awk "BEGIN { printf \"%.1fM\", $total_tok / 1000000 }")
  elif [ "$total_tok" -ge 1000 ]; then
    tok_label=$(awk "BEGIN { printf \"%.1fk\", $total_tok / 1000 }")
  else
    tok_label="${total_tok}"
  fi
  tok_segment="${tok_label} tok"
else
  tok_segment=""
fi

# Build rate limit segment (Claude.ai subscribers only; absent until first API response)
five_pct=$(echo "$input"    | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at       // empty')
week_pct=$(echo "$input"    | jq -r '.rate_limits.seven_day.used_percentage  // empty')
week_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at        // empty')

# Helper: produce "resets in Xh Ym" or "resets in Ym" given a Unix epoch
resets_label() {
  local epoch="$1"
  local now
  now=$(date +%s)
  local secs=$(( epoch - now ))
  if [ "$secs" -le 0 ]; then
    echo "resetting"
    return
  fi
  local h=$(( secs / 3600 ))
  local m=$(( (secs % 3600) / 60 ))
  if [ "$h" -gt 0 ]; then
    printf "resets in %dh %dm" "$h" "$m"
  else
    printf "resets in %dm" "$m"
  fi
}

rate_segment=""
if [ -n "$five_pct" ] || [ -n "$week_pct" ]; then
  parts=""
  if [ -n "$five_pct" ]; then
    five_int=$(printf '%.0f' "$five_pct")
    # Colour: green < 70 %, yellow 70-89 %, red >= 90 %
    if [ "$five_int" -ge 90 ]; then
      rc='\033[0;31m'
    elif [ "$five_int" -ge 70 ]; then
      rc='\033[0;33m'
    else
      rc='\033[0;32m'
    fi
    if [ -n "$five_resets" ]; then
      rl=$(resets_label "$five_resets")
      parts=$(printf "${rc}5h: %d%% (%s)\033[0m" "$five_int" "$rl")
    else
      parts=$(printf "${rc}5h: %d%%\033[0m" "$five_int")
    fi
  fi
  if [ -n "$week_pct" ]; then
    week_int=$(printf '%.0f' "$week_pct")
    if [ "$week_int" -ge 90 ]; then
      wc='\033[0;31m'
    elif [ "$week_int" -ge 70 ]; then
      wc='\033[0;33m'
    else
      wc='\033[0;32m'
    fi
    if [ -n "$week_resets" ]; then
      wrl=$(resets_label "$week_resets")
      week_fmt=$(printf "${wc}7d: %d%% (%s)\033[0m" "$week_int" "$wrl")
    else
      week_fmt=$(printf "${wc}7d: %d%%\033[0m" "$week_int")
    fi
    if [ -n "$parts" ]; then
      parts="${parts} ${week_fmt}"
    else
      parts="${week_fmt}"
    fi
  fi
  rate_segment="$parts"
fi

# Assemble final line
if [ -n "$tok_segment" ]; then
  base=$(printf "%s | %s | %s | %s" "$model" "$dir" "$tok_segment" "$ctx_segment")
else
  base=$(printf "%s | %s | %s" "$model" "$dir" "$ctx_segment")
fi

if [ -n "$rate_segment" ]; then
  printf "%s | %s" "$base" "$rate_segment"
else
  printf "%s" "$base"
fi
