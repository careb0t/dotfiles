# New Machine Setup

Steps to run after pulling and stowing the dotfiles on a new machine.

---

## 1. Update Omarchy

Run this first — it will automatically install several packages that the dotfiles depend on:

```sh
omarchy-update
```

This handles: `tmux`, `lazygit`, `brightnessctl`, and other base system packages.

### Claude Code (automatic, nothing to run)

As of Omarchy 4.0 there's no `claude-code` package and no `/usr/bin/claude` —
`omarchy-update` provisions `claude` (along with `gh`, `codex`, and `node`)
automatically as `mise`-managed stubs straight into `~/.local/bin`. There's
no prompt to accept and nothing to install; `claude` is just available after
step 1 runs.

`~/.local/bin/claude` is a small wrapper script (`mise use -g claude` then
`mise x claude`) that resolves to a version under
`~/.local/share/mise/installs/claude/` and keeps itself current via mise.
Since `.zshrc` puts `~/.local/bin` earlier in `$PATH`, this takes precedence
over anything else named `claude` going forward.

## 2. Install Remaining Packages

These are not managed by omarchy and must be installed manually via the omarchy menu (`Alt+Super+Space` → Install).

**Official repo** (Install → Package):
- `ffmpeg`
- `gifski` (required for `mp4gif` — high-quality GIF encoding)
- `nodejs` (Install → Development → JavaScript)
- `ouch` (required for yazi to preview archive files — `.zip`, `.tar.gz`, `.rar`, etc.)
- `syncthing` (see step 8 for setup)
- `python-pillow` and `pyside6` (required for `gifcollage` — see step 10)
- `python-curl_cffi` (required for yt-dlp to impersonate a browser on adult sites that block bot requests — this used to be AUR-only as `python-curl-cffi-git`, but has since been packaged officially under this name)

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

Adult sites typically require two things beyond a standard yt-dlp call:

1. **Browser impersonation** — handled by `python-curl_cffi` (installed above). Without it, yt-dlp gets a 403 Forbidden before it can even read the page.

2. **A cookies file** — needed to pass age verification. yt-dlp on Hyprland cannot decrypt Vivaldi's v11 cookies from the keyring, so export manually:
   - Install the **"Get cookies.txt LOCALLY"** extension in Vivaldi
   - Navigate to the site while logged in and past age verification
   - Click the extension and export cookies for the domain
   - Place the file at `~/.config/yt-dlp/<domain>_cookies.txt`, e.g. for a site at `example.com`:
     ```
     ~/.config/yt-dlp/www.example.com_cookies.txt
     ```

Then download using the `-p` flag, which auto-detects the domain and loads the matching cookie file:

```sh
mp4dl -p https://www.example.com/video/...
mp4dl -p https://www.example.com/video/... output.mp4
```

The flag works with any site — just name the cookie file after the domain as shown above.

## 3. Install pnpm

```sh
curl -fsSL https://get.pnpm.io/install.sh | sh -
```

## 4. Stow Dotfiles

From the dotfiles repo root:

```sh
stow .
```

This puts the tmux config at `~/.config/tmux/tmux.conf`, which TPM needs in
place *before* the next step (see below).

## 5. Install Tmux Plugin Manager (TPM) & tmuxp

### TPM

tmux itself is installed by omarchy-update, but TPM must be set up manually.
**Do this after stowing (step 4), not before:** TPM auto-detects an
XDG-style config at `~/.config/tmux/tmux.conf` and, if present, redirects
all plugin installs to `~/.config/tmux/plugins/`; if that file isn't there
yet when TPM first runs, it silently falls back to installing into the
legacy `~/.tmux/plugins/` instead, and plugins end up in the wrong place.

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

(TPM itself is always cloned to this fixed path regardless of the XDG
redirect above — only where it installs the *other* plugins moves.)

Then open tmux and press `C-Space` then `I` to install all plugins:
- tmux-continuum
- tmux-resurrect
- tmux-smooth-scroll
- vim-tmux-navigator

The tmux config lives at `~/.config/tmux/tmux.conf` and is managed via stow. It sources the omarchy base config and layers user overrides on top.

### tmuxp (session templates)

`tmuxp` is a standalone session-launcher CLI (Python, built on `libtmux`), not
a TPM plugin — it runs *before* tmux starts rather than inside an
already-running server, so TPM's plugin model has no way to provide it.
Install it as a normal package:

```sh
sudo pacman -S tmuxp
```

Config lives at `~/.config/tmuxp/dev.yaml`, stow-managed the same way as
`tmux.conf`. It defines a `dev` session with three windows — `nvim`,
`shell`, `claude` — none of which set a `start_directory`, so all three open
wherever `tmuxp load` was actually run from:

```yaml
session_name: dev
windows:
  - window_name: nvim
    panes:
      - nvim
  - window_name: shell
    panes:
      - null
  - window_name: claude
    panes:
      - claude
```

Launch it from any project directory with the `tdev` alias (`tmuxp load -y
dev`, defined in `.zshrc`).

## 6. Neovim — First Launch

Open nvim and let lazy.nvim auto-install plugins. The following will install automatically:
- `neocodeium` (AI completions — requires Node.js, installed in step 2)
- `nvim-tmux-navigation` (tmux/nvim pane nav)

### Omarchy Neovim theme template override

`~/.config/omarchy/themed/neovim.lua.tpl` fixes an upstream Omarchy bug: its
bundled `neovim.lua.tpl` (used to generate `neovim.lua` for any theme that
doesn't ship its own hand-authored one — e.g. Last Horizon, Ethereal, Lupine,
Miasma, Ristretto, Vantablack, White, Aether) never sets `bg_highlight` for
the `aether.nvim` colorscheme plugin. That field drives cursor-word/LSP
reference highlighting, Telescope selection, Flash matches, etc., so it
silently falls back to `aether.nvim`'s hardcoded `#000000` default — on a
dark theme, that makes highlighted word matches render as unreadable black
boxes. `aether.nvim` also has its own bug where the "read reference" highlight
group leaks a stale `fg` equal to the editor background from an earlier merge
step, so the matched text itself goes near-invisible too.

This override maps `bg_highlight` to the theme's `muted` color (the closest
semantic fit, and available in every Omarchy theme's `colors.toml`) and
resets the broken reference group via `on_highlights`. Omarchy checks
`~/.config/omarchy/themed/` for a same-named template before falling back to
its own bundled one, so this applies automatically to any current or future
theme generated the templated way — no per-theme action needed.

Stow-managed like the rest of `~/.config/omarchy`'s tracked files — `stow .`
in step 4 creates the link, nothing manual needed here.

If you're on a theme this already generated *before* the fix existed (check
`~/.local/state/omarchy/current/theme/neovim.lua` for a `bg_highlight` key),
re-apply the theme to force regeneration: `omarchy theme set "<name>"`.

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

Also add this rule so the yazi file picker (see step 9) opens floating and centered instead of tiling like a normal window. It matches on the `--title=termfilechooser` set by `TERMCMD` in the termfilechooser config, so it only applies to yazi-as-file-picker — regular ghostty/yazi usage is unaffected:

```lua
o.window(
  { class = "^com.mitchellh.ghostty$", initial_title = "^termfilechooser$" },
  { float = true, size = { 1200, 800 }, center = true }
)
```

After editing any of these, validate with `hyprctl reload` followed by `hyprctl configerrors`.

## 8. Set Up Syncthing

Keeps a folder synced live between machines — pick whatever path and label
make sense for what you're syncing (e.g. `~/Videos/<something>`). The folder
behaves like a normal local directory in Thunar/Yazi — no separate GUI or
command needed to add, remove, or edit files once this is set up. You can
share more than one folder this way; just repeat the "Share the folder" step
below per folder.

Enable the service (starts now and on every login):

```sh
systemctl --user enable --now syncthing.service
```

Create the folder you want to sync, e.g.:

```sh
mkdir -p ~/Videos/<folder-name>
```

Open `http://127.0.0.1:8384` and go to Settings → GUI to set a username/password
(the web UI is reachable on the local network by default).

Pair the two devices: on each machine, go to Actions → Show ID and copy the
device ID. On each machine, go to Remote Devices → Add Device and paste in the
*other* machine's device ID, then accept the pairing prompt that appears on the
other machine.

Share the folder: on one machine, go to Folders → Add Folder, set the path to
your folder, give it a label, then under that folder's Sharing tab enable
sharing with the other device. On the other machine, accept the incoming
folder-share prompt and set its path to match.

Once both sides show the folder as "Up to Date," any file dropped into it on
either machine syncs to the other automatically. The web GUI is only needed
for this one-time setup, never for everyday file adds/removes.

**Note:** Syncthing's config isn't stow-managed (it's runtime state, not
static config) — its config lives at `~/.local/state/syncthing/config.xml`,
not `~/.config/syncthing/`, if you ever need to inspect it directly.

## 9. Set Up Yazi as the System File Picker

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

## 10. gifcollage (animated GIF/WebP collage viewer)

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

## 11. Install Omarchy Shell Plugins

These bar widgets are third-party Omarchy shell plugins, cloned from git into
`~/.config/omarchy/plugins/`. Neither that directory nor
`~/.config/omarchy/shell.json` is stow-managed — `shell.json` carries live
session state (Spotify auth/search history, scroll positions, etc.), so it's
intentionally not tracked in the repo. That means the plugins themselves,
and the bar layout that places them, don't carry over to a new machine and
must be reinstalled:

```sh
omarchy plugin add https://github.com/mtolhuys/omarchy-theme-manager.git --enable
omarchy plugin add https://github.com/stappmus/Omarchy-Spotify.git --enable
omarchy plugin add https://github.com/ilyaZar/omarchy-syncthing.git --enable
omarchy plugin add https://github.com/cempack/ProtonPassPlugin.git --enable
omarchy plugin add https://github.com/jkoestinger/omarchy-vpn.git --enable
omarchy plugin add https://github.com/ssupt/omarchy-audio-control.git --enable
omarchy plugin add https://github.com/stappmus/omarchy-activity-monitor.git --enable
omarchy plugin add https://github.com/mshareef-git/omavibes.git --enable
```

| Plugin | id | Purpose |
|---|---|---|
| [Omarchy Theme Manager](https://github.com/mtolhuys/omarchy-theme-manager) | `io.github.mtolhuys.theme-manager` | Full-screen theme browser/switcher. Not a bar widget (it's an overlay) — replaces the built-in image picker, so leave `omarchy.image-picker` disabled (see below). |
| [Omarchy Spotify](https://github.com/stappmus/Omarchy-Spotify) | `quickshell.spotify` | Spotify controls in the bar for ~60MB vs ~950MB for the official client. |
| [Syncthing](https://github.com/ilyaZar/omarchy-syncthing) | `io.github.ilyazar.syncthing` | Sync health, folder management, and service control from the bar. Pairs with step 8. |
| [Proton Pass](https://github.com/cempack/ProtonPassPlugin) | `io.github.cempack.proton-pass` | Search/copy Proton Pass logins from the bar. |
| [VPN](https://github.com/jkoestinger/omarchy-vpn) | `jkoestinger.vpn` | VPN status/switching in the bar. Auto-detects Mullvad, Proton, Windscribe, or a NetworkManager VPN connection — no extra setup beyond whichever of those you actually use. |
| [Advanced Audio Control](https://github.com/ssupt/omarchy-audio-control) | `ssupt.audio-control` | Expanded PipeWire/WirePlumber mixer — per-app output routing, Bluetooth codecs, mic privacy/testing, audio scenes. Replaces the built-in Audio widget (see below). |
| [Activity Monitor](https://github.com/stappmus/omarchy-activity-monitor) | `stappmus.activity-monitor` | CPU/memory/GPU/storage/process glance. |
| [OmaVibes](https://github.com/mshareef-git/omavibes) | `io.github.mshareef-git.omavibes` | Mute/unmute typing sounds (wayvibes) from the bar, without opening the panel. Paired with a `SUPER+CTRL+M` binding in `bindings.lua`. |

Disable the built-in widgets these plugins replace:

```sh
omarchy plugin disable omarchy.image-picker
omarchy plugin disable omarchy.audio
```

Spotify defaults into the bar's left section and stays there. Every other
plugin above defaults into the right section already; order it to match the
current layout — tray, Syncthing, the built-in agents/bluetooth widgets,
Proton Pass, VPN, Advanced Audio Control, the built-in network widget,
Activity Monitor, OmaVibes, then the built-in monitor/power widgets:

```sh
omarchy bar put io.github.ilyazar.syncthing --after omarchy.tray
omarchy bar put io.github.cempack.proton-pass --after omarchy.bluetooth
omarchy bar put jkoestinger.vpn --after io.github.cempack.proton-pass
omarchy bar put ssupt.audio-control --after jkoestinger.vpn
omarchy bar put stappmus.activity-monitor --after omarchy.network
omarchy bar put io.github.mshareef-git.omavibes --after stappmus.activity-monitor
```

The Spotify widget's keyboard shortcut is rebound in `bindings.lua`
(`SUPER + SHIFT + M`, tracked in the repo) to defer to the plugin's own
"Keyboard shortcut opens" setting instead of Omarchy's default
`omarchy-launch-spotify` — this comes back automatically with `stow .`,
nothing to redo here. OmaVibes' `SUPER+CTRL+M` binding is likewise already
tracked in `bindings.lua`. Everything else — Spotify's shortcut-target
setting, artist-name/scroll-text display, etc. — is a per-widget preference
set from that widget's own settings gear on the bar; reapply to taste.

---

## Notes

- tmux prefix is `C-Space` (secondary: `C-b`); config is at `~/.config/tmux/tmux.conf`
- `tdev` opens the tmuxp `dev` session (nvim/shell/claude windows) rooted at the current directory
- `mp4dl <url>` handles YouTube, Reddit, and X/Twitter downloads
  - X/Twitter downloads use a cookies file at `~/.config/yt-dlp/x.com_cookies.txt` — export from Vivaldi if needed
  - `mp4dl -p <url>` for adult sites — auto-loads `~/.config/yt-dlp/<domain>_cookies.txt`; requires `python-curl_cffi`
- Hyprland binding for tmux terminal: `Super+Alt+Enter`
- `lg` opens lazygit
