Name = "vpnSettings"
NamePretty = "ProtonVPN — Settings"
HideFromProviderlist = true
FixedOrder = true

local HOME = os.getenv("HOME")
local CONF_DIR = HOME .. "/.config/protonvpn/wireguard"

function GetEntries()
  return {
    {
      Text = "󰒓  Setup WireGuard Sudo",
      Subtext = "Show one-time setup instructions",
      Actions = { activate = HOME .. "/.local/bin/vpn-setup" },
      Keywords = { "setup", "sudo", "install" },
    },
    {
      Text = "󰋽  Active WireGuard Status",
      Subtext = "Show detailed connection info",
      Actions = { activate = "vpn-status" },
      Keywords = { "status", "wireguard", "active" },
    },
    {
      Text = "󰉋  Config Directory",
      Subtext = "Where to put your .conf files",
      Actions = { activate = 'notify-send -t 10000 "WireGuard Config Directory" "Put your .conf files in:\n' .. CONF_DIR .. '\n\nFilename = interface name (max 15 chars, no spaces).\nGet configs at protonvpn.com → Dashboard → Downloads → WireGuard"' },
      Keywords = { "directory", "config", "path", "files" },
    },
    {
      Text = "󰇚  Clear Config Cache",
      Subtext = "Force rescan of available configs",
      Actions = { activate = "bash -c 'rm -f /tmp/.vpn-country /tmp/.vpn-fav-country && notify-send -t 3000 ProtonVPN \"Cache cleared\"'" },
      Keywords = { "cache", "clear", "refresh" },
    },
  }
end
