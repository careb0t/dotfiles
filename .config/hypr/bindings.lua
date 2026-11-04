-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- Bindings that now exactly match Omarchy 4.0's stock defaults (Terminal,
-- Browser, Browser private, Music, Music TUI, Docker, Obsidian, Editor) were
-- dropped from here as redundant — the preinstalled bindings already cover
-- them identically.

-- Tmux: always start a fresh session instead of Omarchy's default
-- attach-or-create "Work" session.
-- Note: SUPER+ALT+RETURN was previously bound to Omarchy's default Tmux
-- binding. This unbinds it before rebinding.
hl.unbind("SUPER + ALT + RETURN")
o.bind(
  "SUPER + ALT + RETURN",
  "Tmux",
  'uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" tmux new'
)

-- File manager: yazi TUI instead of Omarchy's default Nautilus.
-- Note: SUPER+SHIFT+F was previously bound to Nautilus. This unbinds it.
-- (Renamed the description from "Terminal" to "File manager (yazi)" — the
-- old bindings.conf had it mislabeled as "Terminal".)
hl.unbind("SUPER + SHIFT + F")
o.bind("SUPER + SHIFT + F", "File manager (yazi)", { tui = "yazi" })

-- Gaming Mode bindings — added by installation script.
-- Note: SUPER+SHIFT+S was previously bound to the Google Maps webapp. This
-- unbinds it.
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Steam Gaming Mode", "/home/careb0t/.local/share/steam-launcher/enter-gamesmode")
o.bind("SUPER + SHIFT + R", "Exit Gaming Mode", "/home/careb0t/.local/share/steam-launcher/leave-gamesmode")
-- End Gaming Mode bindings

hl.unbind("SUPER + SHIFT + M") -- previously: Music
o.bind("SUPER + SHIFT + M", "OmaSpotify", "omarchy shell -q io.github.jeremylanger.omaspotify.player togglePlayer")

-- OmaVibes: mute/unmute typing sounds without opening the panel — handy for
-- gaming sessions where the sound effects are more distracting than useful.
-- IpcHandler target "io.github.mshareef-git.omavibes" → toggleMute() checks
-- whether wayvibes is actually running (not a cached flag) and kills/resumes
-- it accordingly, remembering the active pack across the toggle — see
-- OmaVibesState.qml's toggleMute()/muteCheckProc in the plugin repo.
o.bind("SUPER + CTRL + M", "Toggle typing sounds", "omarchy shell -q io.github.mshareef-git.omavibes toggleMute")
