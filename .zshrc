# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load omarchy-zsh configuration
if [[ -d /usr/share/omarchy-zsh/conf.d ]]; then
  for config in /usr/share/omarchy-zsh/conf.d/*.zsh; do
    [[ -f "$config" ]] && source "$config"
  done
fi

# Load omarchy-zsh functions and aliases
if [[ -d /usr/share/omarchy-zsh/functions ]]; then
  for func in /usr/share/omarchy-zsh/functions/*.zsh; do
    [[ -f "$func" ]] && source "$func"
  done
fi

# Add your own customizations below

# add Claude to PATH for using local installation
export PATH="$HOME/.local/bin:$PATH"

# ~/bin for local scripts (e.g. makegif)
export PATH="$HOME/bin:$PATH"

# pnpm
export PNPM_HOME="/home/careb0t/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# ZPlug plugin manager
source ~/.zplug/init.zsh

zplug "zsh-users/zsh-autosuggestions"
zplug "marlonrichert/zsh-autocomplete"
zplug "zdharma-continuum/fast-syntax-highlighting"
zplug "MichaelAquilina/zsh-autoswitch-virtualenv"
zplug "le0me55i/zsh-extract"
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh

zplug load

# Aliases
alias ls='eza -lh -a --group-directories-first --icons=auto'
mp4dl() {
  local url="$1"
  local output="$2"
  case "$url" in
    *reddit.com/*|*redd.it/*|*v.redd.it/*)
      output="${output:-$(echo "$url" | cut -d'/' -f 8)}"
      output="${output%.*}"
      local tmpfile=$(mktemp --suffix=.mp4)
      reddit-video-downloader "$url" "$tmpfile" && \
      ffmpeg -i "$tmpfile" -c:v libx264 -c:a aac "${output}.mp4" && \
      rm -f "$tmpfile"
      ;;
    *twitter.com/*|*x.com/*)
      local x_cookies="$HOME/.config/yt-dlp/x.com_cookies.txt"
      local cookie_arg=()
      if [[ -f "$x_cookies" ]]; then
        cookie_arg=(--cookies "$x_cookies")
      else
        echo "Warning: no cookies file found at $x_cookies, trying browser cookies"
        cookie_arg=(--cookies-from-browser vivaldi)
      fi
      if [[ -n "$output" ]]; then
        yt-dlp -S "vcodec:h264,res,ext:mp4:m4a" --remux-video mp4 "${cookie_arg[@]}" -o "$output" "$url"
      else
        yt-dlp -S "vcodec:h264,res,ext:mp4:m4a" --remux-video mp4 "${cookie_arg[@]}" "$url"
      fi
      ;;
    *)
      if [[ -n "$output" ]]; then
        yt-dlp -S "vcodec:h264,res,ext:mp4:m4a" --remux-video mp4 -o "$output" "$url"
      else
        yt-dlp -S "vcodec:h264,res,ext:mp4:m4a" --remux-video mp4 "$url"
      fi
      ;;
  esac
}

mp4gif() {
  if [[ "$1" == "-a" ]]; then
    local files=(*.(mp4|webm|mkv|avi|mov|flv|wmv|m4v|ts|vob|ogv|3gp)(N))
    local total=${#files[@]}

    if (( total == 0 )); then
      echo "No video files found in current directory."
      return 0
    fi

    echo "Found $total video file(s) to process."

    local count=0 skipped=0 failed=()

    for f in "${files[@]}"; do
      local out="${f:r}.gif"
      if [[ -f "$out" ]]; then
        echo "  [skip] $f ($out already exists)"
        (( skipped++ ))
        continue
      fi

      (( count++ ))
      printf "  [%d/%d] Converting: %s -> %s\n" $count $(( total - skipped )) "$f" "$out"

      if ffmpeg -v quiet -stats -i "$f" -loop 0 -filter_complex "fps=10,scale=-1:360[s];[s]split[a][b];[a]palettegen[palette];[b][palette]paletteuse" "$out" 2>&1; then
        printf "         Done. (%s)\n" "$(du -sh "$out" 2>/dev/null | cut -f1)"
      else
        echo "         Failed. Skipping."
        rm -f "$out"
        failed+=("$f")
      fi
    done

    echo ""
    echo "Batch complete: $count converted, $skipped skipped."

    if (( ${#failed[@]} > 0 )); then
      echo "Failed to convert ${#failed[@]} file(s):"
      for f in "${failed[@]}"; do
        echo "  - $f"
      done
      return 1
    fi

    return 0
  fi

  if [[ -z "$1" ]]; then
    printf "Usage: mp4gif <input.(mp4|webm|mkv|...)> [output.gif]\n       mp4gif -a  (convert all video files in current directory, skipping existing gifs)\n"
    return 1
  fi

  local input="$1"
  local output="${2:-${input:r}.gif}"

  echo "Converting: $input -> $output"
  if ffmpeg -v quiet -stats -i "$input" -loop 0 -filter_complex "fps=10,scale=-1:360[s];[s]split[a][b];[a]palettegen[palette];[b][palette]paletteuse" "$output" 2>&1; then
    printf "Done. (%s)\n" "$(du -sh "$output" 2>/dev/null | cut -f1)"
  else
    echo "Error: conversion failed."
    rm -f "$output"
    return 1
  fi
}

# Load ZSH plugins
eval "$(atuin init zsh)"
