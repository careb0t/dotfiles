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

The local install is `mise`-managed: `~/.local/bin/claude` is a small wrapper script (`mise use -g claude` then `mise x claude`) that resolves to a version under `~/.local/share/claude/versions/` and keeps itself current. Since `.zshrc` puts `~/.local/bin` earlier in `$PATH`, this version will take precedence over the system one going forward.

## 2. Install Remaining Packages

These are not managed by omarchy and must be installed manually via the omarchy menu (`Alt+Super+Space` → Install).

**Official repo** (Install → Package):
- `ffmpeg`
- `gifski` (required for `mp4gif` — high-quality GIF encoding)
- `nodejs` (Install → Development → JavaScript)
- `ouch` (required for yazi to preview archive files — `.zip`, `.tar.gz`, `.rar`, etc.)
- `syncthing` (see step 8 for setup)
- `python-pillow` and `pyside6` (required for `gifcollage` — see step 11)
- `python-curl_cffi` (required for yt-dlp to impersonate a browser on sites like Pornhub that block bot requests — this used to be AUR-only as `python-curl-cffi-git`, but has since been packaged officially under this name)

**AUR** (Install → AUR Package):
- `reddit-video-downloader`

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

1. **Browser impersonation** — handled by `python-curl_cffi` (installed above). Without it, yt-dlp gets a 403 Forbidden before it can even read the page.

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
- `syncthingtray` (tray icon for Syncthing, shows up via the omarchy shell's bar tray widget — see step 8)

## 3. Install pnpm

```sh
curl -fsSL https://get.pnpm.io/install.sh | sh -
```

## 4. Install Tmux Plugin Manager (TPM)

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

## 5. Stow Dotfiles

From the dotfiles repo root:

```sh
stow .
```

## 6. Neovim — First Launch

Open nvim and let lazy.nvim auto-install plugins. The following will install automatically:
- `neocodeium` (AI completions — requires Node.js, installed in step 2)
- `nvim-tmux-navigation` (tmux/nvim pane nav)

## 7. Per-Machine Hyprland Lua Config

Omarchy 4.0 configures Hyprland in Lua (`~/.config/hypr/*.lua`). The dotfiles
repo's `hyprland.lua` `require`s `hypr.monitors`, `hypr.input`, and
`hypr.windows` unconditionally, but those three files hold machine-specific
settings (monitor layout, keyboard/touchpad, per-app window rules) and are
**not tracked in the dotfiles repo** — same reasoning as the old
`windows.conf`/`monitors.conf`/etc. Create them manually on each new machine:

```sh
touch ~/.config/hypr/monitors.lua ~/.config/hypr/input.lua ~/.config/hypr/windows.lua
```

(Bootstrap tip: `stow .` will still symlink the repo's `hyprland.lua` even
before these exist, but Hyprland will error on the missing `require`s until
all three files are present — even as empty files.)

**`monitors.lua`** — monitor layout and workspace-to-monitor pins. Example
(adjust output names/modes to `hyprctl monitors all`):

```lua
hl.env("GDK_SCALE", "1")

hl.monitor({ output = "DP-1", mode = "1920x1080@144", position = "auto", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@59", position = "auto", scale = 1 })

hl.workspace_rule({ workspace = "1", monitor = "DP-1" })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1" })
-- ...repeat per workspace as needed.
```

**`input.lua`** — keyboard/touchpad settings, e.g.:

```lua
hl.config({
  input = {
    kb_layout = "us",
    repeat_rate = 40,
    repeat_delay = 600,
    numlock_by_default = true,
    touchpad = { scroll_factor = 0.4 },
  },
})

o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })
```

**`windows.lua`** — per-app window rules. Add the following to make btop open
as a properly sized floating window (omarchy's default floating size is too
small for btop):

```lua
o.window({ class = "^org.omarchy.btop$" }, { tag = "-floating-window" })
o.window({ class = "^org.omarchy.btop$" }, { float = true, size = { 1600, 900 }, center = true })
```

Also add this rule so the yazi file picker (see step 10) opens floating and centered instead of tiling like a normal window. It matches on the `--title=termfilechooser` set by `TERMCMD` in the termfilechooser config, so it only applies to yazi-as-file-picker — regular ghostty/yazi usage is unaffected:

```lua
o.window(
  { class = "^com.mitchellh.ghostty$", initial_title = "^termfilechooser$" },
  { float = true, size = { 1200, 800 }, center = true }
)
```

After editing any of these, validate with `hyprctl reload` followed by `hyprctl configerrors`.

## 8. Set Up Syncthing

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
the web GUI) via the omarchy shell's bar tray widget — autostarted through
`o.launch_on_start('bash -c "sleep 15 && syncthingtray --wait"')` in
`~/.config/hypr/autostart.lua`.

## 9. ProtonVPN (WireGuard)

The VPN picker (`~/.config/elephant/menus/vpn*.lua`) uses `wg-quick` directly — no ProtonVPN daemon or NetworkManager required.

**Currently disabled pending Omarchy 4.0 conversion:** these menu scripts were written for `walker`/`elephant`, which no longer exist in Omarchy 4.0 (replaced by the omarchy-shell menu system). The `Super+Shift+V` binding is commented out in `bindings.lua` until they're converted to the new menu format. The rest of this section (sudoers, WireGuard configs) still applies — only the launcher/keybind is pending.

### Install dependencies

```sh
sudo pacman -S openresolv
```

`openresolv` provides the `resolvconf` command that `wg-quick` uses to apply DNS settings from the VPN config. After installing, initialize it once:

```sh
sudo resolvconf -u
```

### Allow wg-quick and resolvectl to run without a password prompt

The menu launches `wg-quick` and `resolvectl` via `sudo` in the background where there's no terminal for a password prompt. Create a sudoers rule that allows both passwordlessly:

```sh
echo 'careb0t ALL=(ALL) NOPASSWD: /usr/bin/wg-quick, /usr/bin/resolvconf, /usr/bin/resolvectl' | sudo tee /etc/sudoers.d/protonvpn-wg && sudo chmod 440 /etc/sudoers.d/protonvpn-wg
```

Replace `careb0t` with the local username if different.

**Why `resolvectl` is required:** on systems where `/etc/resolv.conf` is managed by `systemd-resolved` (the default here), `wg-quick`'s built-in DNS handling (which shells out to `resolvconf`) fights `systemd-resolved` for ownership of that file. Every time `systemd-resolved` regenerates its stub file, it wipes `resolvconf`'s signature, so the next connect's `resolvconf -a` call gets rejected with `resolvconf: signature mismatch: /etc/resolv.conf` and `wg-quick` tears the tunnel back down — this reliably broke every connection attempt after the first disconnect. To fix it, `vpn-connect` strips the `DNS =` line before handing the config to `wg-quick` and instead sets DNS itself via `resolvectl dns`/`resolvectl domain`, which talks to `systemd-resolved` directly over D-Bus instead of racing it over a file. `vpn-disconnect` calls `resolvectl revert` on teardown for the same reason. `resolvconf` is still in the sudoers rule as a harmless no-op fallback but is no longer load-bearing for DNS.

### Download WireGuard configs

1. Log in at protonvpn.com → **Dashboard → Downloads → WireGuard**
2. Generate a config for each server you want
3. Rename each file — the filename becomes the network interface name, so it must be **≤15 characters, no spaces**
   - `CZ-33.conf` ✓ — Czech Republic server #33
   - `ProtonVPN_US-AZ-1.conf` ✗ — too long (17 chars), wg-quick will fail
4. Place the renamed files in `~/.config/protonvpn/wireguard/`

The menu reads the filenames and turns them into display names automatically — `CZ-33.conf` shows as **Czech Republic #33**, `US-1.conf` as **United States #1**, etc.

## 10. Set Up Yazi as the System File Picker

Routes file open/save dialogs in GTK, Chromium/Electron (Vivaldi, Discord clients), Qt6, and Steam through yazi (in a ghostty window) instead of the native GTK/Thunar file chooser.

### Install the portal backend (AUR)

Install via the omarchy menu: `Alt+Super+Space` → Install → AUR Package → `xdg-desktop-portal-termfilechooser`.

### Config (already stowed)

- `~/.config/xdg-desktop-portal-termfilechooser/config` — tells the portal to use the bundled `yazi-wrapper.sh`, and sets `TERMCMD=ghostty --title=termfilechooser --font-size=14 -e` so the picker opens in ghostty at a readable size instead of the tiny default.
- `~/.config/xdg-desktop-portal/hyprland-portals.conf` — sets `org.freedesktop.impl.portal.FileChooser=termfilechooser` as preferred, so the portal picks this over GTK for file dialogs while leaving other portal interfaces (screenshot, screen-share, etc.) on `hyprland;gtk`.
- `~/.config/hypr/hyprland.lua` — sets `GTK_USE_PORTAL=1` via `hl.env(...)`, which is what makes GTK's native file chooser widget (used internally by GTK apps, Chromium/Electron, and Steam) delegate to the portal instead of showing its own dialog. Also sets `QT_QPA_PLATFORMTHEME=xdgdesktopportal`, enabled by default, which does the same for Qt6 apps (qBittorrent, Kdenlive, Qt Designer, etc.) via Qt's built-in portal theme plugin.

**Note:** on a machine where these files already exist as plain files (not yet stow-managed), `stow .` will refuse to symlink over them — move or remove the existing real files first.

### Apply changes

`GTK_USE_PORTAL` only takes effect for processes started after it's exported, so **log out and back in (or reboot)** after stowing. Then restart the portal services once to pick up the new preferred-backend config:

```sh
systemctl --user restart xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
```

### Verify

```sh
gdbus call --session --dest org.freedesktop.portal.Desktop --object-path /org/freedesktop/portal/desktop --method org.freedesktop.portal.FileChooser.OpenFile "" "Pick a file" "{}"
```

A ghostty window running yazi should pop up.

**Known gap:** Firefox-based browsers (Floorp, Zen Browser) don't honor `GTK_USE_PORTAL` — they need `widget.use-xdg-desktop-portal.file-picker` set to `1` via `user.js` in each profile. Not yet set up.

## 11. gifcollage (animated GIF/WebP collage viewer)

Opens a single window showing a rotating grid of animated GIFs and animated
WebPs from a directory you pick interactively. Lives at
`~/.local/bin/gifcollage`, symlinked from the dotfiles repo via stow like the
`vpn-*` scripts.

### Dependencies

- `fzf`, `fd` — already installed by `omarchy-update` (step 1)
- `python-pillow`, `pyside6` — install manually (step 2); used to detect
  animated WebPs and to render the grid (`QLabel`/`QMovie` natively animate
  both GIF and WebP)

### Usage

```sh
gifcollage [SEARCH_ROOT] [--grid N] [--interval SECONDS] [--once] [--letterbox]
```

Run it in a terminal:

1. fzf prompts you to pick the target directory (browsing starts at
   `SEARCH_ROOT`, default `$HOME`).
2. A second fzf (multi-select with Tab) lets you exclude subdirectories from
   the scan.
3. Every `.gif` and *animated* `.webp` file under the target directory
   (minus excluded subdirs) is collected, shuffled, and split across an
   N×N grid (default 4×4, auto-shrinks if there are fewer files than
   cells). Each cell swaps to its next file on its own randomized timer
   (averaging `--interval` seconds), so the whole grid doesn't flip at
   once.

Flags:
- `--grid N` — max grid size, N×N (default `4`)
- `--interval SECONDS` — average seconds between a cell's swaps (default `2`)
- `--once` — close the window once every cell has shown its files once,
  instead of looping forever
- `--letterbox` — fit each animation entirely inside its cell (preserves
  aspect ratio, adds black bars) instead of the default crop-to-fill

---

## Notes

- tmux prefix is `C-Space` (secondary: `C-b`); config is at `~/.config/tmux/tmux.conf`
- `mp4dl <url>` handles YouTube, Reddit, and X/Twitter downloads
  - X/Twitter downloads use a cookies file at `~/.config/yt-dlp/x.com_cookies.txt` — export from Vivaldi if needed
  - `mp4dl -p <url>` for adult sites — auto-loads `~/.config/yt-dlp/<domain>_cookies.txt`; requires `python-curl_cffi`
- Hyprland binding for tmux terminal: `Super+Alt+Enter`
- `lg` opens lazygit
