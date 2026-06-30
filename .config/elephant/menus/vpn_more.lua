Name = "vpnMore"
NamePretty = "ProtonVPN — More"
HideFromProviderlist = true
FixedOrder = true

function GetEntries()
  return {
    {
      Text = "󰋽  Status",
      Subtext = "Show current connection status",
      Actions = { activate = "vpn-status" },
      Keywords = { "status", "info", "connection" },
    },
    {
      Text = "󰒓  Settings",
      Subtext = "WireGuard setup and config info",
      Actions = { activate = "walker -m menus:vpnSettings --maxheight 800" },
      Keywords = { "settings", "setup", "config" },
    },
    {
      Text = "󰋗  Help",
      Subtext = "Setup guide and feature explanations",
      Actions = { activate = "walker -m menus:vpnHelp --maxheight 800" },
      Keywords = { "help", "info", "setup" },
    },
  }
end
