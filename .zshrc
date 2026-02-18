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
    *)
      if [[ -n "$output" ]]; then
        yt-dlp -S res,ext:mp4:m4a --recode mp4 --postprocessor-args "VideoConvertor:-c:v libx264 -c:a aac" -o "$output" "$url"
      else
        yt-dlp -S res,ext:mp4:m4a --recode mp4 --postprocessor-args "VideoConvertor:-c:v libx264 -c:a aac" "$url"
      fi
      ;;
  esac
}

# Load ZSH plugins
eval "$(atuin init zsh)"
