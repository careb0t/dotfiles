# New Machine Setup

Steps to run after pulling and stowing the dotfiles on a new machine.

---

## 1. Update Omarchy

Run this first — it will automatically install several packages that the dotfiles depend on:

```sh
omarchy-update
```

This handles: `tmux`, `claude-code`, `lazygit`, `brightnessctl`, and other base system packages.

### Install Claude Code locally (user bin)

Omarchy installs `claude-code` to `/usr/bin/claude`, but on first run it will offer to install a self-updating local copy to `~/.local/bin` instead. Run it once and accept the prompt:

```sh
claude
```

The local install lands at `~/.local/share/claude/` and is symlinked from `~/.local/bin/claude`. Since `.zshrc` puts `~/.local/bin` earlier in `$PATH`, this version will take precedence over the system one going forward.

## 2. Install Remaining Packages

These are not managed by omarchy and must be installed manually via the omarchy menu (`Alt+Super+Space` → Install).

**Official repo** (Install → Package):
- `ffmpeg`
- `gifski` (required for `mp4gif` — high-quality GIF encoding)
- `nodejs` (Install → Development → JavaScript)
- `ouch` (required for yazi to preview archive files — `.zip`, `.tar.gz`, `.rar`, etc.)
- `syncthing` (see step 9 for setup)

**AUR** (Install → AUR Package):
- `reddit-video-downloader`
- `python-curl-cffi-git` (required for yt-dlp to impersonate a browser on sites like Pornhub that block bot requests)

### Install yt-dlp (binary, not pacman)

The pacman version of `yt-dlp` lags significantly behind upstream. Install the official binary directly so it stays current and can self-update:

```sh
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ~/.local/bin/yt-dlp
chmod +x ~/.local/bin/yt-dlp
```

`~/.local/bin` is already on `$PATH` via `.zshrc`, so `yt-dlp` will be found immediately after this. Verify with:

```sh
yt-dlp --version
```

To update yt-dlp in the future:

```sh
yt-dlp -U
```

**mp4dl compatibility:** `mp4dl` calls `yt-dlp` by name for all non-Reddit URLs (YouTube, X/Twitter, etc.). As long as the binary is in `~/.local/bin`, it works with no changes needed. For X/Twitter downloads, also place your cookies file at:

```
~/.config/yt-dlp/x.com_cookies.txt
```

Export it from Vivaldi using a cookies.txt browser extension.

### Adult site downloads (`-p` flag)

Sites like Pornhub require two things beyond a standard yt-dlp call:

1. **Browser impersonation** — handled by `python-curl-cffi-git` (installed above). Without it, yt-dlp gets a 403 Forbidden before it can even read the page.

2. **A cookies file** — needed to pass age verification. yt-dlp on Hyprland cannot decrypt Vivaldi's v11 cookies from the keyring, so export manually:
   - Install the **"Get cookies.txt LOCALLY"** extension in Vivaldi
   - Navigate to the site while logged in and past age verification
   - Click the extension and export cookies for the domain
   - Place the file at `~/.config/yt-dlp/<domain>_cookies.txt`, e.g.:
     ```
     ~/.config/yt-dlp/www.pornhub.com_cookies.txt
     ```

Then download using the `-p` flag, which auto-detects the domain and loads the matching cookie file:

```sh
mp4dl -p https://www.pornhub.com/view_video.php?viewkey=...
mp4dl -p https://www.pornhub.com/view_video.php?viewkey=... output.mp4
```

The flag works with any site — just name the cookie file after the domain as shown above.
- `syncthingtray` (tray icon for Syncthing, shows up via waybar's tray module — see step 9)

## 3. Install Font — ShureTechMono Nerd Font

The default font was changed from JetBrainsMono to ShureTechMono. Install via the omarchy menu (`Alt+Super+Space` → Install → Package):

- `ttf-sharetech-mono-nerd`

Then verify ghostty/waybar/hyprlock render correctly.

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
- tmux-resurrect
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
- `neocodeium` (AI completions — requires Node.js, installed in step 2)
- `nvim-tmux-navigation` (tmux/nvim pane nav)

## 8. Create Hyprland Window Rules

`~/.config/hypr/windows.conf` is not tracked in the dotfiles repo (it varies per machine). Create it manually:

```sh
touch ~/.config/hypr/windows.conf
```

Add the following to make btop open as a properly sized floating window (omarchy's default floating size is too small for btop):

```
windowrule = tag -floating-window*, match:class org.omarchy.btop

windowrule {
    name = btop-floating
    match:class = ^org.omarchy.btop$
    float = on
    size = 1600 900
    center = on
}
```

## 9. Set Up Syncthing

Keeps `~/Videos/Goon` synced live between machines. The folder behaves like a
normal local directory in Thunar/Yazi — no separate GUI or command needed to
add, remove, or edit files once this is set up.

Enable the service (starts now and on every login):

```sh
systemctl --user enable --now syncthing.service
```

Create the synced folder:

```sh
mkdir -p ~/Videos/Goon
```

Open `http://127.0.0.1:8384` and go to Settings → GUI to set a username/password
(the web UI is reachable on the local network by default).

Pair the two devices: on each machine, go to Actions → Show ID and copy the
device ID. On each machine, go to Remote Devices → Add Device and paste in the
*other* machine's device ID, then accept the pairing prompt that appears on the
other machine.

Share the folder: on one machine, go to Folders → Add Folder, set the path to
`~/Videos/Goon`, label it (e.g. "Goon"), then under that folder's Sharing tab
enable sharing with the other device. On the other machine, accept the incoming
folder-share prompt and set its path to `~/Videos/Goon` too.

Once both sides show the folder as "Up to Date," any file dropped into
`~/Videos/Goon` on either machine syncs to the other automatically. The web GUI
is only needed for this one-time setup, never for everyday file adds/removes.

`syncthingtray` provides a tray icon (sync status, pause/resume, quick link to
the web GUI) via waybar's existing tray module — autostarted through
`exec-once = uwsm-app -- syncthingtray` in `~/.config/hypr/autostart.conf`.

## 10. ProtonVPN (WireGuard)

The VPN menu (`Super+Shift+V`) uses `wg-quick` directly — no ProtonVPN daemon or NetworkManager required.

### Install dependencies

```sh
sudo pacman -S openresolv
```

`openresolv` provides the `resolvconf` command that `wg-quick` uses to apply DNS settings from the VPN config. After installing, initialize it once:

```sh
sudo resolvconf -u
```

### Allow wg-quick and resolvconf to run without a password prompt

The menu launches `wg-quick` and `resolvconf` via `sudo` in the background where there's no terminal for a password prompt. Create a sudoers rule that allows both passwordlessly:

```sh
echo 'careb0t ALL=(ALL) NOPASSWD: /usr/bin/wg-quick, /usr/bin/resolvconf' | sudo tee /etc/sudoers.d/protonvpn-wg && sudo chmod 440 /etc/sudoers.d/protonvpn-wg
```

Replace `careb0t` with the local username if different.

`resolvconf` must be included alongside `wg-quick` because the connect/disconnect scripts run `resolvconf -u` automatically after each VPN teardown. This prevents a signature mismatch error (`resolvconf: signature mismatch: /etc/resolv.conf`) that would otherwise block the next connection attempt.

### Download WireGuard configs

1. Log in at protonvpn.com → **Dashboard → Downloads → WireGuard**
2. Generate a config for each server you want
3. Rename each file — the filename becomes the network interface name, so it must be **≤15 characters, no spaces**
   - `CZ-33.conf` ✓ — Czech Republic server #33
   - `ProtonVPN_US-AZ-1.conf` ✗ — too long (17 chars), wg-quick will fail
4. Place the renamed files in `~/.config/protonvpn/wireguard/`

The menu reads the filenames and turns them into display names automatically — `CZ-33.conf` shows as **Czech Republic #33**, `US-1.conf` as **United States #1**, etc.

---

## Notes

- tmux prefix is `C-Space` (secondary: `C-b`); config is at `~/.config/tmux/tmux.conf`
- `mp4dl <url>` handles YouTube, Reddit, and X/Twitter downloads
  - X/Twitter downloads use a cookies file at `~/.config/yt-dlp/x.com_cookies.txt` — export from Vivaldi if needed
  - `mp4dl -p <url>` for adult sites — auto-loads `~/.config/yt-dlp/<domain>_cookies.txt`; requires `python-curl-cffi-git` from AUR
- Hyprland binding for tmux terminal: `Super+Alt+Enter`
- `lg` opens lazygit
