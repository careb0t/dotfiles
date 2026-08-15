-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")
require("hypr.windows")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.

-- Route GTK/Chromium/Electron file open/save dialogs (Vivaldi, Discord clients,
-- Steam) through xdg-desktop-portal instead of the native GTK chooser, so the
-- termfilechooser portal (configured to use yazi) is used instead.
hl.env("GTK_USE_PORTAL", "1")

-- Same, but for Qt6 apps (qBittorrent, Kdenlive, Qt Designer, etc.) — routes
-- their file dialogs through the portal via Qt's built-in portal theme plugin.
hl.env("QT_QPA_PLATFORMTHEME", "xdgdesktopportal")
