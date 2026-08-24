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

-- Extra Activity shortcut (Omarchy's default is SUPER+CTRL+T).
o.bind("SUPER + SHIFT + T", "Activity", { tui = "btop" })

-- Gaming Mode bindings — added by installation script.
-- Note: SUPER+SHIFT+S was previously bound to the Google Maps webapp. This
-- unbinds it.
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Steam Gaming Mode", "/home/careb0t/.local/share/steam-launcher/enter-gamesmode")
o.bind("SUPER + SHIFT + R", "Exit Gaming Mode", "/home/careb0t/.local/share/steam-launcher/leave-gamesmode")
-- End Gaming Mode bindings

-- Music: defer to the quickshell.spotify plugin's own setting-aware
-- toggle instead of Omarchy's default omarchy-launch-spotify (which
-- always opens the native app and knows nothing about the plugin).
-- IpcHandler target "quickshell.spotify.player" → togglePlayer() reads
-- the plugin's "Keyboard shortcut opens" setting (Omarchy Music app /
-- Full player / Mini player) and dispatches accordingly — see
-- BarWidget.qml's toggleConfiguredPlayerShortcut() in the plugin repo.
-- Change which one this key opens from the plugin's own Settings panel,
-- not here.
-- Note: SUPER+SHIFT+M was previously bound to Omarchy's default Music
-- binding. This unbinds it before rebinding.
hl.unbind("SUPER + SHIFT + M")
o.bind("SUPER + SHIFT + M", "Music", "omarchy shell -q quickshell.spotify.player togglePlayer")
