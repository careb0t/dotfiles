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

## 12. Vivaldi Keyring Unlock Fix

Fixes "Vivaldi could not unlock your secure key store" on launch, with no
password prompt offered (just quit / continue-with-data-loss). First seen
2026-09-09 after an `omarchy update` bumped Vivaldi 8.1 → 8.2. Two separate
bugs stacked here; both needed fixing.

**Bug 1 — the portal interface didn't exist under Hyprland.** Vivaldi 8.2's
new `OSCryptAsync` encryption-key subsystem talks to the xdg-desktop-portal
Secret interface (`org.freedesktop.portal.Secret`) instead of going straight
to `org.freedesktop.secrets` (gnome-keyring) like older Vivaldi did — and it
**ignores `--password-store` entirely**; that flag only affects a legacy code
path this build no longer uses for provider *selection* (confirmed by testing
every value directly against the `vivaldi-bin` binary — none changed which
backend got used, see Bug 2's flag for the one that actually works).
`gnome-keyring` *does* ship a portal backend for Secret
(`/usr/share/xdg-desktop-portal/portals/gnome-keyring.portal`), but that file
is scoped `UseIn=gnome`, so xdg-desktop-portal never auto-selects it under
Hyprland — `org.freedesktop.portal.Desktop` didn't expose the Secret
interface at all (`gdbus introspect` on it showed no such interface). Fixed
by adding `org.freedesktop.impl.portal.Secret=gnome-keyring` to
`~/.config/xdg-desktop-portal/hyprland-portals.conf`'s `[preferred]` section
— same mechanism step 9 already uses for `FileChooser=termfilechooser`.

**Bug 2 — fixing Bug 1 uncovered a key mismatch.** Once the portal interface
existed, Vivaldi's portal-based key retrieval started *succeeding*
(`Local State`'s `os_crypt.portal.prev_init_success` went `true`) — but it
turned out to retrieve a **different secret** than the one that actually
encrypted this profile's existing logins/cookies (the pre-existing
`Chrome Safe Storage` item in gnome-keyring, schema
`chrome_libsecret_os_crypt_password_v2`, confirmed still present and
untouched via `gdbus` the whole time). Vivaldi's own
`vivaldi_keystore_checker.cc` correctly detects this and refuses to proceed
silently, logging `KeystoreChecker: ... Encrypted keystore changed or is now
unavailable` and showing the same "could not unlock" dialog — just for a
different underlying reason than Bug 1. **Never click "Continue with Data
Loss" on this dialog** — it discards the mismatched profile data; "quit" or
"switch profile" are safe (confirmed: the original keyring item was
unaffected after choosing either).

Fixed by disabling the portal key provider outright via
`~/.config/vivaldi-stable.conf` (see below), forcing `OSCryptAsync` back onto
the classic `FreedesktopSecretKeyProvider`, which talks directly to
`org.freedesktop.secrets` and reuses the original, matching key.

### Config (already stowed)

- `~/.config/xdg-desktop-portal/hyprland-portals.conf` — adds
  `org.freedesktop.impl.portal.Secret=gnome-keyring` to `[preferred]` (Bug 1).
- `~/.config/vivaldi-stable.conf` — Vivaldi's wrapper script
  (`/opt/vivaldi/vivaldi`) sources `~/.config/vivaldi-$CHROME_VERSION_EXTRA.conf`
  (`$CHROME_VERSION_EXTRA` is `"stable"`) and passes its contents as extra
  flags to the real binary. Sets
  `--disable-features=SecretPortalKeyProviderUseForEncryption` (Bug 2),
  applying regardless of how Vivaldi gets launched (app launcher, taskbar,
  terminal, keybinding).

### Apply changes

```sh
systemctl --user restart xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
```

Then fully quit Vivaldi (check `pgrep -f vivaldi-bin` — it's multi-process,
closing the last window doesn't always kill all of them) and relaunch it.

### Verify

```sh
# Bug 1 — portal interface exists:
gdbus introspect --session --dest org.freedesktop.portal.Desktop \
  --object-path /org/freedesktop/portal/desktop | grep -A2 'interface org.freedesktop.portal.Secret'

# Bug 2 — the flag is actually being passed:
pgrep -af vivaldi-bin | grep -o -- '--disable-features=[A-Za-z,]*'
```

First should show the `RetrieveSecret` method; second should print the flag.
Both fixes were verified end-to-end against real data without touching the
live profile: copy `Local State` + `Default/{Cookies,Login Data,Web Data}`
from the real (Chill) profile into a scratch `--user-data-dir`, launch
`vivaldi-bin --user-data-dir=<scratch>` against it, and check for the
`KeystoreChecker: ... Encrypted keystore changed` line in stderr — present
and reproducible without the `--disable-features` flag, silent (no error,
which is how this checker reports success) with it.

**Update 2026-09-09:** after fixing Bugs 1 and 2 above, the exact same
keystore-mismatch error kept recurring anyway. The actual cause turned out to
be a **third, unrelated bug** — this machine had two separate keyrings, and
the wrong one was set as the system default. See step 13; that's almost
certainly what a future "could not unlock" report on this or the laptop
means, even after Bugs 1 and 2's fixes are already in place. This machine's
SDDM autologin skipping the PAM auth step (`gkr-pam: no password is
available for user` in `journalctl -b`) is still real and worth knowing
about, but turned out to be a red herring for this particular recurring
failure, not its cause.

---

## 13. Quattro Upgrade: Orphaned Duplicate Keyring

Some Omarchy Quattro migration (2026-08-15, see the Omarchy Quattro upgrade
memory) left this machine with **two separate keyring files** instead of
one, and the wrong one set as the system default:

```
~/.local/share/keyrings/Default_Keyring.keyring   <- the REAL one (capital K)
~/.local/share/keyrings/Default_keyring.keyring   <- an orphaned duplicate (lowercase k)
~/.local/share/keyrings/default                   <- was pointing at the lowercase one
```

The real keyring accumulated months of actual secrets — GitHub, Proton SSO,
pass-cli, the Omarchy Spotify plugin's refresh token, and (critically) the
correct browser encryption key. The lowercase one is sparse — just a handful
of items various apps freshly (re-)created after the migration silently
orphaned the real one. Whatever app any of your secrets belong to, if it
looks emptied out / like it forgot everything after a Quattro upgrade, check
here before assuming the app or its config is broken — this can masquerade
as almost any "app can't find my saved password/keyring" symptom, not just
Vivaldi's.

### Diagnose

```sh
# Which one is currently set as default:
cat ~/.local/share/keyrings/default

# Compare how much each one actually holds -- the real one has many more
# items with recognizable labels (GitHub, Proton, etc); an orphaned one
# freshly created post-migration will look sparse:
busctl --user tree org.freedesktop.secrets | grep collection
```

If there are two `Default_*Keyring` (or similarly near-duplicate-named)
collections and the one with your actual accounts in it isn't what
`~/.local/share/keyrings/default` names, this is the bug.

### Real mechanism (confirmed 2026-09-26)

This machine's SDDM autologin never gives `pam_gnome_keyring` a real password
(`pam_permit.so` satisfies auth first) — the real keyring can never be
auto-unlocked via PAM. Whenever `gnome-keyring-daemon` (re)starts and finds
the aliased default collection locked, it silently creates a fresh blank
collection and rebinds the `default` alias to it
(`CreateCollection(label="Default keyring", alias="default")` always rebinds
per the Secret Service D-Bus spec). This is the daemon's own startup
behavior, not anything app-specific — confirmed by restarting the daemon
alone (no other app running) and watching the orphan reappear every time.

### Permanent fix: blank the real keyring's password

Given this disk is LUKS-encrypted (`nvme0n1p2`) and autologin already grants
full session access with zero password barrier, a separately
password-protected keyring adds no real protection in either state (off =
LUKS covers it; on = autologin already grants full access) — so the durable
fix is GNOME's own supported "auto-unlock" mechanism: blank the real
keyring's password via Seahorse (Passwords tab → right-click the real
"Default keyring" → Change Password → enter current password → leave new
password blank → confirm the "stored unencrypted" warning). This removes the
daemon's reason to ever fall back to a fresh collection, since it can always
load and auto-unlock the real one instantly with zero PAM dependency.

This was a **deliberate choice** given this machine's specific LUKS+autologin
posture — re-evaluate if either changes (e.g. autologin gets disabled, or
this gets replicated on a machine without full-disk encryption). The
alternative (disable autologin so PAM can legitimately capture a password) is
more defense-in-depth but costs a password prompt every boot.

### Bug hit applying that fix: Seahorse corrupts PEM-containing items

Seahorse's "Change Password" → blank rewrites the file into GNOME's plaintext
GKeyFile format (`[keyring]` / `display-name=...`, expected and correct for a
blank-password keyring) — but it has a real bug: any item whose secret
contains embedded literal `\n` sequences (e.g. a JSON blob holding PEM
`-----BEGIN/END...-----` blocks) gets written with **raw newlines instead of
escaped `\n`**, breaking the GKeyFile line format. Symptom:
`gnome-keyring-daemon` logs `keyring was in an invalid or unrecognized
format: .../Default_Keyring.keyring` on load and falls into the exact same
orphan-creation behavior above — except now permanently, since the file
itself is broken, not just locked.

**Diagnose** — validate with GLib's own parser (the same one the daemon
uses), not just `file`:

```python
import gi; gi.require_version('GLib', '2.0')
from gi.repository import GLib
kf = GLib.KeyFile.new()
kf.load_from_file('/home/careb0t/.local/share/keyrings/Default_Keyring.keyring', GLib.KeyFileFlags.NONE)
```

A `g-key-file-error-quark` naming a line that looks like the middle of a PEM
block confirms this bug.

**Repair** (never print the file's raw contents — it holds live secrets):
read the file; for every line that isn't a section header (`^\[.*\]$`), a
`key=value` line, a comment, or blank, treat it as a broken continuation of
the *previous* line and rejoin with a literal `\n` (two characters) instead
of a real newline:

```python
import re, shutil, gi
gi.require_version('GLib', '2.0')
from gi.repository import GLib

src = '/home/careb0t/.local/share/keyrings/Default_Keyring.keyring'
backup = '/path/to/scratch/Default_Keyring.keyring.corrupt.bak'
repaired = '/path/to/scratch/Default_Keyring.keyring.repaired'
shutil.copy2(src, backup)

with open(src, 'r', encoding='utf-8', errors='surrogateescape') as f:
    lines = f.read().split('\n')

section_re = re.compile(r'^\[.*\]$')
key_re = re.compile(r'^[A-Za-z0-9_.\-]+(\[[^\]]+\])?\s*=')

out_lines = []
for line in lines:
    if section_re.match(line) or key_re.match(line) or line.strip() == '' or line.startswith('#'):
        out_lines.append(line)
    else:
        out_lines[-1] = out_lines[-1] + '\\n' + line  # rejoin broken continuation

with open(repaired, 'w', encoding='utf-8', errors='surrogateescape') as f:
    f.write('\n'.join(out_lines))

kf = GLib.KeyFile.new()
kf.load_from_file(repaired, GLib.KeyFileFlags.NONE)  # raises if still invalid
print('groups:', len(kf.get_groups()[0]))
```

Re-validate with `GLib.KeyFile.load_from_file` before touching the live file
— a successful parse recovering the expected item count (compare against
`busctl --user tree org.freedesktop.secrets | grep collection` from before
the corruption) confirms the repair is sound. Sanity-check by listing each
item group's `display-name` only (never `secret=` values) to confirm labels
look sane (e.g. `kf.get_string(group, 'display-name')` per group).

### Apply and verify

```sh
systemctl --user stop gnome-keyring-daemon.service
cp -p <repaired file> ~/.local/share/keyrings/Default_Keyring.keyring
chmod 600 ~/.local/share/keyrings/Default_Keyring.keyring
echo -n "Default_Keyring" > ~/.local/share/keyrings/default
rm -f ~/.local/share/keyrings/Default_keyring.keyring
systemctl --user start gnome-keyring-daemon.service
journalctl --user -u gnome-keyring-daemon --since "10 sec ago" --no-pager  # should show no "invalid format" line
```

**Verify durability with a *second* restart** — a real blank-password fix
shows `Locked: false` (an explicit `Unlock` call should succeed instantly
with an empty prompt path if it doesn't auto-unlock immediately) on every
restart, with the orphan file never reappearing. One clean restart isn't
proof; the bug specifically only showed up across a restart.

**Known gap:** a handful of items got written to the *wrong* (orphaned)
keyring during the original split (confirmed: at least one duplicate Proton
SSO entry existed in both, with possibly-differing values) — anything set up
fresh during that window may need re-entering once noticed missing. Not
fully audited/reconciled.

### The actual permanent fix (2026-09-26): proactively unlock at boot

The blank-password fix above is necessary but **not sufficient on its own**.
The real collection starts every daemon startup in a nominal `Locked: true`
state (even though unlocking it is trivial/instant with no prompt, since it
has no password) — and whichever app happens to ask for "the default
collection" *first*, before anything explicitly calls `Unlock`, can still
trip the same "locked → fabricate a blank replacement, steal the alias"
fallback. This isn't tied to any one app: `proton-vpn-cli`'s Python keyring
backend triggered it while installed; removing `pam_gnome_keyring.so` from
`sddm-autologin`'s PAM stack (its `gkr-pam: couldn't unlock the login
keyring` failure was *a* trigger, confirmed via `journalctl -b`) reduced but
did **not** eliminate it — it recurred again on a clean reboot with both of
those removed. Chasing every possible racing app individually is whack-a-mole
by nature; the actual fix is to close the race itself.

**Fix:** a user-level systemd unit that proactively calls `Unlock` on the
real collection the instant `gnome-keyring-daemon` is up, before any other
app gets a chance to ask. No sudo needed — pure `~/.config` and `~/.local`.

- `~/.local/bin/unlock-default-keyring.sh` — polls (up to ~10s) until the
  `Unlock` D-Bus call against
  `/org/freedesktop/secrets/collection/Default_5fKeyring` succeeds, then
  exits. The polling loop is needed because `gnome-keyring-daemon.service`
  is `Type=simple`, so systemd doesn't wait for it to finish loading
  collections from disk before considering it "started."
- `~/.config/systemd/user/unlock-default-keyring.service` — `oneshot`,
  `After=`/`Requires=gnome-keyring-daemon.service`, `WantedBy=default.target`.
  Enable with `systemctl --user enable --now unlock-default-keyring.service`.

**Both files are intentionally excluded from `stow .`** via
`.stow-local-ignore` — they're only needed on a machine that actually hits
this bug (autologin + a keyring that's had its password blanked). They're
git-tracked so they're available after a pull on any machine (e.g. the
laptop, if it ends up on autologin too), but won't get auto-symlinked and
silently activated somewhere that doesn't need them. To actually deploy on
another machine: copy (not stow) the two files to their listed paths, then:

```sh
chmod +x ~/.local/bin/unlock-default-keyring.sh
systemctl --user daemon-reload
systemctl --user enable --now unlock-default-keyring.service
```

Verified 2026-09-26: survived a real reboot cleanly (not just a mid-session
`systemctl --user restart`, which had previously given false confidence more
than once during this investigation) — real keyring unlocked, correctly
aliased, no orphan file created, Vivaldi opened without the "could not
unlock" error.

### Recurrence 2026-10-02: auto-repair the PEM corruption before every daemon start

The PEM raw-newline corruption above came back with no Seahorse involved:
some app saved an item at 08:33, gnome-keyring's own plaintext writer
re-broke the file, and nothing noticed until the daemon crashed (SIGABRT)
that night and its restart fell back to a fresh empty keyring + "new
keyring password" prompt. So the bug is in the daemon's blank-password
serializer: **any secret write can re-corrupt the file**, and it only bites
on the next daemon start. The boot-unlock unit can't help with that.

**Fix:** a guard that runs before *every* daemon start (boot, crash
restarts, manual restarts), validates the file with GLib's own parser, and
if it's broken applies the same rejoin repair as above, re-validates, saves
the corrupt copy to `~/.local/state/keyring-repair/`, swaps the file in
atomically, and sends a desktop notification. If repair fails it leaves the
file untouched and sends a critical notification. It never blocks the daemon
from starting and never prints secret values. Encrypted (password-protected)
keyring files are skipped.

- `~/.local/bin/check-default-keyring.py`
- `~/.config/systemd/user/gnome-keyring-daemon.service.d/check-keyring.conf`
  (`ExecStartPre=-` drop-in on the stock unit)

Also excluded from `stow .`. To deploy: copy both to their paths, then
`chmod +x ~/.local/bin/check-default-keyring.py && systemctl --user daemon-reload`.

Verified 2026-10-02 by putting the real corrupt file in place and starting
the daemon: repaired before load, 15 items, unlocked, no orphan keyring.

### Recurrence 2026-11-01: the unlock script's success check was a lie

The orphan came back on a boot where the file was valid. Two bugs in
`unlock-default-keyring.sh` as originally written:

- `Unlock` on a collection path that doesn't exist (yet) still returns
  success with an empty unlocked list, so the script could "succeed" before
  the real collection had loaded and leave it locked — race reopened.
- Its first call ran before the daemon owned `org.freedesktop.secrets`, so
  dbus-broker auto-started a *second* daemon (`discover_other_daemon: 1` in
  the journal) and that call's success meant nothing either.

Also, once the alias had been stolen, nothing ever put it back: the guard
repaired the file on the next boot but `default` kept pointing at the orphan.
And the standalone unit only ran at boot, not on crash restarts.

**Fix:** the script now calls with `--auto-start=no`, counts success only
when the `Locked` property reads `false`, then checks `ReadAlias default` and
`SetAlias`es it back to `Default_5fKeyring` (with a notification) if needed.
It runs as `ExecStartPost=-` in the same `check-keyring.conf` drop-in, so it
covers boot and every restart. `unlock-default-keyring.service` was removed
(`systemctl --user disable` it on any machine that had it). Deploy is now
just the two scripts + the drop-in, then `systemctl --user daemon-reload`.

Also confirmed live: a single item write (`set_secret` on any item) re-corrupts
the file instantly. The running daemon keeps the collection in memory and
carries on, so the corruption only matters at the next start, where
`ExecStartPre` repairs it.

### Recurrence 2026-11-01 (again, after reboot): daemon wasn't started at boot, and a heal watcher

Removing `unlock-default-keyring.service` also removed the only thing that
started `gnome-keyring-daemon.service` at boot (its `Requires=`); the stock
unit is not enabled. So the daemon was first started by an autostart app's
D-Bus call, and the stock D-Bus service file has no `SystemdService=`, so
dbus-broker spawned a bare daemon outside the unit: no `ExecStartPre`/`Post`
guards, racing app requests → orphan again.

**Fix, three layers:**

1. `systemctl --user enable gnome-keyring-daemon.service`, so it starts at
   boot via `default.target`, before the graphical session's apps.
2. `~/.local/share/dbus-1/services/org.freedesktop.secrets.service`: a
   user override (wins over `/usr/share`, journal shows "Ignoring duplicate
   name") adding `SystemdService=gnome-keyring-daemon.service`, so any D-Bus
   activation goes through the unit and its drop-in.
3. `~/.local/bin/heal-default-keyring.py`, run at the end of
   `unlock-default-keyring.sh` (every daemon start) and by
   `heal-default-keyring.path` on any change in `~/.local/share/keyrings/`:
   resets the `default` alias to `Default_5fKeyring` (raw D-Bus — libsecret
   fails on a dangling alias), then for every collection labelled
   "Default keyring"/"Default"/"Login" other than the real one: backs up
   stray files to `~/.local/state/keyring-repair/*.stray`, moves its items into
   the real keyring (matching attributes → newer value wins, except encryption
   keys like "Safe Storage"/portal keys, where the real one always wins), and
   deletes it. Notifies when it did something. So whatever creates a stray in
   future, it's undone within a second without touching Seahorse.

Deploy: copy the three scripts, the drop-in, `heal-default-keyring.{path,service}`
and the D-Bus file, then `systemctl --user daemon-reload && systemctl --user enable
gnome-keyring-daemon.service heal-default-keyring.path`, and reload D-Bus
(`busctl --user call org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus ReloadConfig`).

Verified (not yet across a reboot): a planted stray keyring holding a fake
duplicate Chrome Safe Storage key + a new item, plus a dangling alias, got
healed on daemon restart (real Chrome key hash unchanged, new item moved, stray
deleted); D-Bus activation with the unit stopped now starts it through
systemd (one daemon, guards ran).

---

## 14. ProtonVPN CLI: Stuck Process Holds Lock, Looks Like Every Command Is Broken

`proton-vpn-cli` (`protonvpn`) and the `jkoestinger.vpn` Omarchy bar plugin
(step 11) serialize CLI invocations via exclusive flock files at
`/run/user/1000/omarchy-vpn-protonvpn.lock` and
`/run/user/1000/Proton/proton-sso.lock`. If one invocation gets stuck (first
seen 2026-09-26: it ran while the real keyring was locked/broken — see step
13 — and blocked forever in `do_epoll_wait` waiting on a secret-service
response that never arrived), it holds that lock **indefinitely**, and every
subsequent `protonvpn` command — yours, and the bar plugin's background
polling — queues up behind it and also appears to hang, even though each new
invocation is otherwise perfectly healthy. Looks exactly like "everything is
broken" when it's really one zombie process from hours earlier.

### Diagnose

```sh
ps -eo pid,ppid,etimes,stat,cmd | grep -i protonvpn | grep -v grep   # etimes = seconds alive
lslocks | grep -i proton                                             # exclusive FLOCK WRITE holder
cat /proc/<pid>/wchan                                                 # do_epoll_wait = blocked on I/O that'll never come
```

### Fix

```sh
kill -9 <pid>
```

flock releases immediately on process exit — the next `protonvpn` command
runs normally right away. No reboot or daemon restart needed. Check this
*first* for any future "protonvpn hangs" report (10-second check) before
digging into keyring/daemon state again.

---

## Notes

- tmux prefix is `C-Space` (secondary: `C-b`); config is at `~/.config/tmux/tmux.conf`
- `tdev` opens the tmuxp `dev` session (nvim/shell/claude windows) rooted at the current directory
- `mp4dl <url>` handles YouTube, Reddit, and X/Twitter downloads
  - X/Twitter downloads use a cookies file at `~/.config/yt-dlp/x.com_cookies.txt` — export from Vivaldi if needed
  - `mp4dl -p <url>` for adult sites — auto-loads `~/.config/yt-dlp/<domain>_cookies.txt`; requires `python-curl_cffi`
- Hyprland binding for tmux terminal: `Super+Alt+Enter`
- `lg` opens lazygit
