# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load zsh options, keybindings, and completion
[[ -f /usr/share/omarchy-zsh/shell/zoptions ]] && source /usr/share/omarchy-zsh/shell/zoptions

# Load shared shell configuration (aliases, functions, environment, tool init)
[[ -f /usr/share/omarchy-zsh/shell/all ]] && source /usr/share/omarchy-zsh/shell/all

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
alias lg='lazygit'
dotsync() {
  (cd ~/dotfiles && stow . --adopt && git restore .)
}
mp4dl() {
  local porn_mode=0

  while [[ "$1" == -* ]]; do
    case "$1" in
      -p|--porn) porn_mode=1; shift ;;
      *) break ;;
    esac
  done

  local url="$1"
  local output="$2"
  local -a cookie_arg=()

  if (( porn_mode )); then
    local domain
    domain=$(printf '%s' "$url" | awk -F/ '{print $3}')
    local cookie_file="$HOME/.config/yt-dlp/${domain}_cookies.txt"
    if [[ -f "$cookie_file" ]]; then
      cookie_arg=(--cookies "$cookie_file")
    else
      echo "Warning: no cookies file found at $cookie_file"
    fi
  fi

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
      if (( !porn_mode )); then
        local x_cookies="$HOME/.config/yt-dlp/x.com_cookies.txt"
        if [[ -f "$x_cookies" ]]; then
          cookie_arg=(--cookies "$x_cookies")
        else
          echo "Warning: no cookies file found at $x_cookies, trying browser cookies"
          cookie_arg=(--cookies-from-browser vivaldi)
        fi
      fi
      if [[ -n "$output" ]]; then
        yt-dlp -S "vcodec:h264,res,ext:mp4:m4a" --remux-video mp4 "${cookie_arg[@]}" -o "$output" "$url"
      else
        yt-dlp -S "vcodec:h264,res,ext:mp4:m4a" --remux-video mp4 "${cookie_arg[@]}" "$url"
      fi
      ;;
    *)
      if [[ -n "$output" ]]; then
        yt-dlp -S "vcodec:h264,res,ext:mp4:m4a" --remux-video mp4 "${cookie_arg[@]}" -o "$output" "$url"
      else
        yt-dlp -S "vcodec:h264,res,ext:mp4:m4a" --remux-video mp4 "${cookie_arg[@]}" "$url"
      fi
      ;;
  esac
}

_mp4gif_ts2sec() {
  printf "%s" "$1" | awk -F: '
    NF==3 { printf "%.3f", $1*3600+$2*60+$3 }
    NF==2 { printf "%.3f", $1*60+$2 }
    NF==1 { printf "%.3f", $1 }
  '
}

mp4gif() {
  command -v gifski &>/dev/null || { echo "Error: gifski is not installed."; return 1; }
  command -v ffmpeg  &>/dev/null || { echo "Error: ffmpeg is not installed.";  return 1; }

  local small_mode=0 batch_mode=0
  while [[ "$1" == -* ]]; do
    case "$1" in
      -a) batch_mode=1 ;;
      -s) small_mode=1 ;;
      -h|--help)
        printf "Usage: mp4gif [OPTIONS] <input> [output.gif]\n"
        printf "       mp4gif -a  batch convert all videos in current directory\n"
        printf "Options:\n"
        printf "  -a  Batch convert all videos in current directory\n"
        printf "  -s  Small mode for batch conversion (fps=8, width=240, quality=60)\n"
        printf "  -h  Show this help\n"
        return 0 ;;
      *) printf "Unknown option: %s\n" "$1"; return 1 ;;
    esac
    shift
  done

  # ── BATCH MODE ──────────────────────────────────────────────────────────────
  if (( batch_mode )); then
    local files=(*.(mp4|webm|mkv|avi|mov|flv|wmv|m4v|ts|vob|ogv|3gp)(N))
    local total=${#files[@]}
    (( total == 0 )) && { echo "No video files found in current directory."; return 0; }

    printf "Found %d video file(s) to process.\n" "$total"
    local count=0 skipped=0 fps width quality ok
    local -a failed=() frames
    if (( small_mode )); then
      fps=8; width=240; quality=60
    else
      fps=24; width=720; quality=90
    fi

    local f out tmpdir
    for f in "${files[@]}"; do
      out="${f:r}.gif"
      if [[ -f "$out" ]]; then
        printf "  [skip] %s\n" "$f"
        (( skipped++ ))
        continue
      fi
      (( count++ ))
      printf "  [%d/%d] %s -> %s\n" "$count" "$(( total - skipped ))" "$f" "$out"
      tmpdir=$(mktemp -d)
      ok=0
      if ffmpeg -v quiet -i "$f" \
           -vf "fps=${fps},scale=${width}:-1:flags=lanczos" \
           "${tmpdir}/frame%04d.png" 2>/dev/null; then
        frames=("${tmpdir}"/frame*.png)
        if (( ${#frames[@]} > 0 )) && \
           gifski --fps "$fps" --quality "$quality" --repeat 0 \
                  -o "$out" "${frames[@]}" 2>/dev/null; then
          printf "         Done. (%s)\n" "$(du -sh "$out" 2>/dev/null | cut -f1)"
          ok=1
        fi
      fi
      (( ok )) || { printf "         Failed.\n"; rm -f "$out"; failed+=("$f"); }
      rm -rf "$tmpdir"
    done

    printf "\nBatch complete: %d converted, %d skipped.\n" "$count" "$skipped"
    if (( ${#failed[@]} > 0 )); then
      printf "Failed %d file(s):\n" "${#failed[@]}"
      printf "  - %s\n" "${failed[@]}"
      return 1
    fi
    return 0
  fi

  # ── SINGLE FILE MODE ────────────────────────────────────────────────────────
  if [[ -z "$1" ]]; then
    printf "Usage: mp4gif [OPTIONS] <input.(mp4|webm|mkv|...)> [output.gif]\n"
    printf "       mp4gif -a  batch convert all videos in current directory\n"
    printf "       mp4gif -s  small file size mode\n"
    return 1
  fi

  local input="$1" output="${2:-${1:r}.gif}"
  [[ ! -f "$input" ]] && { printf "Error: file not found: %s\n" "$input"; return 1; }

  local total_dur dur_hms
  total_dur=$(ffprobe -v error -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 "$input" 2>/dev/null)
  dur_hms=$(printf "%s" "$total_dur" | awk '{
    h=int($1/3600); m=int(($1-h*3600)/60); s=$1-h*3600-m*60
    printf "%02d:%02d:%05.2f", h, m, s }')
  printf "Input:    %s\n" "$input"
  [[ -n "$total_dur" ]] && printf "Duration: %s (%.1f s)\n" "$dur_hms" "$total_dur"
  printf "Output:   %s\n\n" "$output"

  # ── Time range / quality / convert (looped so the user can retry with new settings) ──
  local start_raw end_raw start_sec end_sec dur_sec start_arg dur_arg
  local fps width quality lossy fps_in width_in quality_in
  local tmpdir frame_count size size_bytes keep
  local -a ffargs frames gargs

  while true; do
    start_raw='' end_raw='' start_sec='' end_sec='' dur_sec='' start_arg='' dur_arg=''
    read -r "start_raw?Start time [HH:MM:SS or seconds, enter=beginning]: "
    read -r "end_raw?End time   [HH:MM:SS or seconds, enter=end]:       "

    if [[ -n "$start_raw" ]]; then
      start_sec=$(_mp4gif_ts2sec "$start_raw")
      start_arg="$start_raw"
    fi
    if [[ -n "$end_raw" ]]; then
      end_sec=$(_mp4gif_ts2sec "$end_raw")
      dur_sec=$(awk -v e="$end_sec" -v s="${start_sec:-0}" 'BEGIN { printf "%.3f", e - s }')
      if ! awk -v d="$dur_sec" 'BEGIN { exit !(d > 0) }'; then
        echo "Error: end time must be after start time."
        return 1
      fi
      dur_arg="$dur_sec"
    fi

    # ── Quality settings ──
    lossy=""
    if (( small_mode )); then
      fps=8; width=240; quality=60; lossy=80
      printf "Small file size mode: fps=%s, width=%s px, quality=%s\n\n" "$fps" "$width" "$quality"
    else
      read -r "fps_in?FPS          [default=24]:  "
      read -r "width_in?Max width px  [default=720]: "
      read -r "quality_in?Quality 1-100 [default=90]:  "
      fps=${fps_in:-24}
      width=${width_in:-720}
      quality=${quality_in:-90}
    fi

    printf "\nConverting: %s -> %s\n" "$input" "$output"

    tmpdir=$(mktemp -d) || { echo "Error: could not create temp directory."; return 1; }

    ffargs=(-v quiet -stats)
    [[ -n "$start_arg" ]] && ffargs+=(-ss "$start_arg")
    ffargs+=(-i "$input")
    [[ -n "$dur_arg" ]] && ffargs+=(-t "$dur_arg")
    ffargs+=(-vf "fps=${fps},scale=${width}:-1:flags=lanczos" "${tmpdir}/frame%04d.png")

    printf "Extracting frames...\n"
    if ! ffmpeg "${ffargs[@]}"; then
      printf "Error: frame extraction failed.\n"
      rm -rf "$tmpdir"
      return 1
    fi

    frames=("${tmpdir}"/frame*.png)
    frame_count=${#frames[@]}
    printf "%d frames extracted. Building GIF...\n" "$frame_count"

    if (( frame_count == 0 )); then
      printf "Error: no frames extracted.\n"
      rm -rf "$tmpdir"
      return 1
    fi

    gargs=(--fps "$fps" --quality "$quality" --repeat 0)
    [[ -n "$lossy" ]] && gargs+=(--lossy-quality "$lossy")
    gargs+=(-o "$output")

    if ! gifski "${gargs[@]}" "${frames[@]}"; then
      printf "Error: gifski failed.\n"
      rm -f "$output"
      rm -rf "$tmpdir"
      return 1
    fi

    rm -rf "$tmpdir"

    size=$(du -sh "$output" 2>/dev/null | cut -f1)
    size_bytes=$(stat -c%s "$output" 2>/dev/null || echo 0)
    printf "\nDone. Output: %s (%s)\n" "$output" "$size"

    # ── Over 50 MB: let the user keep it, or delete it and re-enter settings ──
    if (( size_bytes > 52428800 && !small_mode )); then
      printf "\nWarning: GIF is %s (>50 MB). Keep this file, or delete it and try again with new settings? [k]eep/[d]elete: " "$size"
      read -r keep
      if [[ "$keep" =~ ^[Dd] ]]; then
        rm -f "$output"
        printf "\nDeleted. Let's try again.\n\n"
        continue
      fi
    fi
    break
  done
}

# Load ZSH plugins
eval "$(atuin init zsh)"

export PATH=$PATH:/home/careb0t/.spicetify
