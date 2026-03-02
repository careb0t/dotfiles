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

# gifcom requires: gifsicle (sudo pacman -S gifsicle)
_gifcom_bytes() {
  # Accepts upper or lowercase units: 10m, 500K, 2G, 1024 (bytes)
  local input="${1:u}"
  if [[ "$input" == *K ]]; then
    printf '%d' $(( ${input%K} * 1024 ))
  elif [[ "$input" == *M ]]; then
    printf '%d' $(( ${input%M} * 1024 * 1024 ))
  elif [[ "$input" == *G ]]; then
    printf '%d' $(( ${input%G} * 1024 * 1024 * 1024 ))
  elif [[ "$input" =~ '^[0-9]+$' ]]; then
    printf '%d' "$input"
  else
    printf ''
  fi
}

gifcom() {
  if [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]]; then
    printf "Usage: gifcompress <max_size> [-o <outdir>] [-s <suffix>] [file1.gif ...]\n"
    printf "       max_size: e.g. 5M, 500k, 2G, 1024 (bytes) — upper or lowercase\n"
    printf "       -o <outdir>   output directory (created if needed; default: current dir)\n"
    printf "       -s <suffix>   filename suffix for compressed copies (default: _sm)\n"
    printf "       If no files given, all GIFs in current dir exceeding max_size are processed.\n"
    printf "       Example: gifcompress 5M -o ./small -s _compressed anim.gif\n"
    return 1
  fi

  if ! command -v gifsicle &>/dev/null; then
    echo "Error: gifsicle is not installed. Install with: sudo pacman -S gifsicle"
    return 1
  fi

  local max_size_str="$1"
  shift

  local max_bytes
  max_bytes=$(_gifcom_bytes "$max_size_str")
  if [[ -z "$max_bytes" ]] || (( max_bytes <= 0 )); then
    echo "Error: invalid size '$max_size_str'. Use e.g. 5M, 500k, 1024"
    return 1
  fi

  # Parse flags (-o and -s) before file arguments
  local outdir="" suffix="_sm"
  while [[ "$1" == -* ]]; do
    case "$1" in
      -o)
        if [[ -z "$2" ]]; then
          echo "Error: -o requires a directory argument"
          return 1
        fi
        outdir="$2"
        shift 2
        ;;
      -s)
        if [[ -z "$2" ]]; then
          echo "Error: -s requires a suffix argument"
          return 1
        fi
        suffix="$2"
        shift 2
        ;;
      *)
        echo "Error: unknown flag '$1'"
        return 1
        ;;
    esac
  done

  if [[ -n "$outdir" ]] && [[ ! -d "$outdir" ]]; then
    echo "Creating output directory: $outdir"
    mkdir -p "$outdir" || { echo "Error: could not create directory '$outdir'"; return 1 }
  fi

  local files=()
  if (( $# > 0 )); then
    files=("$@")
    echo "Processing ${#files[@]} specified file(s)..."
  else
    echo "Scanning current directory for GIFs over $max_size_str..."
    for f in *.gif(N); do
      local sz
      sz=$(stat -c%s "$f" 2>/dev/null)
      (( sz > max_bytes )) && files+=("$f")
    done
    echo "Found ${#files[@]} GIF(s) exceeding $max_size_str."
  fi

  if (( ${#files[@]} == 0 )); then
    echo "Nothing to do."
    return 0
  fi

  echo ""
  echo "Target max size : $max_size_str"
  echo "Output suffix   : $suffix"
  [[ -n "$outdir" ]] && echo "Output directory: $outdir" || echo "Output directory: (current)"
  echo ""

  # Progressive quality presets: colors:lossy — lossless first, then increasingly lossy
  local presets=("256:0" "128:0" "256:20" "128:40" "64:80" "32:120" "16:200")

  local total=${#files[@]} done_count=0 skipped=0 failed=()

  for f in "${files[@]}"; do
    if [[ ! -f "$f" ]]; then
      echo "  [error] $f — file not found, skipping."
      failed+=("$f — file not found")
      echo ""
      continue
    fi

    local sz
    sz=$(stat -c%s "$f" 2>/dev/null)
    if (( sz <= max_bytes )); then
      printf "  [skip]  %s — already under %s (%s)\n\n" "$f" "$max_size_str" "$(du -sh "$f" | cut -f1)"
      (( skipped++ ))
      continue
    fi

    local outname="${f:t:r}${suffix}.gif"
    local outpath="${outdir:+${outdir}/}${outname}"

    (( done_count++ ))
    printf "  [%d/%d] %s (%s) -> %s\n" $done_count $(( total - skipped )) "$f" "$(du -sh "$f" | cut -f1)" "$outpath"

    local tmpfile
    tmpfile=$(mktemp --suffix=.gif)
    local success=0

    for preset in "${presets[@]}"; do
      local colors="${preset%%:*}" lossy="${preset##*:}"
      local args=(-O3 --colors "$colors")
      (( lossy > 0 )) && args+=(--lossy="$lossy")

      local label="${colors} colors"
      (( lossy > 0 )) && label+=", lossy=${lossy}"

      printf "         Trying: %s... " "$label"

      if ! gifsicle "${args[@]}" "$f" -o "$tmpfile" 2>/dev/null; then
        echo "gifsicle error, skipping this preset."
        continue
      fi

      local newsize
      newsize=$(stat -c%s "$tmpfile" 2>/dev/null)

      if (( newsize > 0 && newsize <= max_bytes )); then
        if cp "$tmpfile" "$outpath" 2>/dev/null; then
          printf "%s — under target! Saved.\n" "$(du -sh "$tmpfile" | cut -f1)"
          success=1
        else
          echo "copy failed — check permissions for '$outpath'."
          failed+=("$f — could not write to $outpath")
        fi
        break
      fi

      printf "%s — still over target.\n" "$(du -sh "$tmpfile" | cut -f1)"
    done

    rm -f "$tmpfile"

    if (( !success )); then
      echo "         Could not reach target size. Skipping."
      failed+=("$f — could not compress below $max_size_str")
    fi

    echo ""
  done

  # Summary
  echo "──────────────────────────────────────"
  echo "Done. $done_count compressed, $skipped skipped."

  if (( ${#failed[@]} > 0 )); then
    echo ""
    echo "Errors (${#failed[@]} file(s)):"
    for entry in "${failed[@]}"; do
      echo "  - $entry"
    done
    return 1
  fi
}

# Load ZSH plugins
eval "$(atuin init zsh)"
