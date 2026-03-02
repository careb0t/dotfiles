# Laptop Sync Checklist

Steps to run after pulling updated dotfiles on the laptop.

---

## 1. Update Omarchy

Run this first — it will automatically install several packages that the dotfiles depend on:

```sh
omarchy-update
```

This handles: `tmux`, `claude-code`, `brightnessctl`, and other base system packages added since the last sync.

### Install Claude Code locally (user bin)

Omarchy installs `claude-code` to `/usr/bin/claude`, but on first run it will offer to install a self-updating local copy to `~/.local/bin` instead. Run it once and accept the prompt:

```sh
claude
```

The local install lands at `~/.local/share/claude/` and is symlinked from `~/.local/bin/claude`. Since `.zshrc` puts `~/.local/bin` earlier in `$PATH`, this version will take precedence over the system one going forward.

## 2. Install Remaining Packages

These are not managed by omarchy and must be installed manually:

```sh
yay -S yt-dlp ffmpeg reddit-video-downloader gifsicle
```

> `gifsicle` is required by the `gifcom` zshrc alias for compressing GIFs.

## 3. Install Font — ShureTechMono Nerd Font

The default font was changed from JetBrainsMono to ShureTechMono. Search AUR for the correct package:

```sh
yay -Ss sharetechmono nerd
```

Install the result, then verify ghostty/waybar/hyprlock render correctly.

## 4. Install pnpm

```sh
curl -fsSL https://get.pnpm.io/install.sh | sh -
```

## 5. Install Tmux Plugin Manager (TPM)

tmux itself is installed by omarchy-update, but TPM must be set up manually:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then open tmux and press `C-Space` then `I` to install all plugins:
- tmux-continuum
- tmux-resurrect (azorng/tmux-smooth-scroll)
- tmux-smooth-scroll
- vim-tmux-navigator

The tmux config now lives at `~/.config/tmux/tmux.conf` and is managed via stow. It sources the omarchy base config and layers user overrides on top.

## 6. Stow Dotfiles

From the dotfiles repo root:

```sh
stow .
```

## 7. Neovim — First Launch

Open nvim and let lazy.nvim auto-install plugins. The following will install automatically:
- `neocodeium` (AI completions — requires Node.js)
- `nvim-tmux-navigation` (tmux/nvim pane nav)

Make sure **Node.js** is installed or neocodeium won't work:

```sh
yay -S nodejs
```

---

## Notes

- tmux prefix is `C-Space` (secondary: `C-b`); config is at `~/.config/tmux/tmux.conf`
- `mp4dl <url>` handles YouTube, Reddit, and X/Twitter downloads
  - X/Twitter downloads use a cookies file at `~/.config/yt-dlp/x.com_cookies.txt` — export from Vivaldi if needed
- Hyprland binding for tmux terminal: `Super+Alt+Enter`
