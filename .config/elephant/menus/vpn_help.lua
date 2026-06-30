Name = "vpnHelp"
NamePretty = "ProtonVPN — Help"
HideFromProviderlist = true
FixedOrder = true

local HOME = os.getenv("HOME")
local CONF_DIR = HOME .. "/.config/protonvpn/wireguard"

function GetEntries()
  return {
    {
      Text = "󰒓  Getting Started",
      Subtext = "How to set up WireGuard with ProtonVPN",
      Actions = { activate = 'notify-send -t 20000 "Getting Started" "1. Go to protonvpn.com → Dashboard → Downloads → WireGuard\n2. Generate a config for each server/country you want\n3. Save .conf files in:\n   ' .. CONF_DIR .. '\n4. Keep filenames short (max 15 chars, no spaces)\n5. Run More → Settings → Setup WireGuard Sudo (once)\n6. You can now connect from this menu"' },
      Keywords = { "start", "setup", "install", "how" },
    },
    {
      Text = "󰖟  Quick Connect",
      Subtext = "Connects to the first config file alphabetically",
      Actions = { activate = 'notify-send -t 10000 "Quick Connect" "Connects to the first .conf file found in your WireGuard config directory, sorted alphabetically. Name your preferred default server something that sorts first (e.g. \'00-default.conf\') to control which server Quick Connect picks."' },
      Keywords = { "quick", "connect", "fastest" },
    },
    {
      Text = "󰍉  By Country",
      Subtext = "Groups your configs by 2-letter country code",
      Actions = { activate = 'notify-send -t 12000 "By Country" "Groups your WireGuard configs by the 2-letter country code at the start of each filename (e.g. US-East.conf → US group). If you only have one config per country, clicking the country connects directly. Multiple configs show a server list to choose from."' },
      Keywords = { "country", "group", "select" },
    },
    {
      Text = "󰏛  By City",
      Subtext = "Browse all servers grouped by country",
      Actions = { activate = 'notify-send -t 10000 "By City" "Same as By Country but always shows the server list for each country, letting you pick a specific server. Useful when you have multiple configs per country (e.g. US-East.conf, US-West.conf)."' },
      Keywords = { "city", "server", "select" },
    },
    {
      Text = "󰆥  P2P Servers",
      Subtext = "Torrenting and file sharing",
      Actions = { activate = 'notify-send -t 14000 "P2P Servers" "ProtonVPN has servers optimized for P2P (torrenting). Download a WireGuard config for a P2P server from protonvpn.com, then name it something like \'US-P2P.conf\'. You can then add it as a favorite or connect via the server list. P2P servers are in countries with favorable laws for file sharing."' },
      Keywords = { "p2p", "torrent", "file", "sharing" },
    },
    {
      Text = "󰌿  Secure Core",
      Subtext = "Double-hop for extra privacy",
      Actions = { activate = 'notify-send -t 16000 "Secure Core" "Secure Core routes traffic through two servers: a hardened server in Switzerland, Iceland, or Sweden, then through an exit server. Even if the exit is monitored, your real IP stays hidden behind the Secure Core server. Download a Secure Core WireGuard config from protonvpn.com (labeled \'SC\' in the server list). Expect slower speeds due to the double hop."' },
      Keywords = { "secure", "core", "privacy", "double" },
    },
    {
      Text = "⭐  Favorites",
      Subtext = "Pin countries or servers for one-click access",
      Actions = { activate = 'notify-send -t 12000 "Favorites" "Save frequently used countries or specific servers as favorites. They appear pinned at the top of the main VPN menu. Country favorites connect to the first matching .conf file for that country code. Server favorites connect to the exact server by name. Manage via More → Manage Favorites."' },
      Keywords = { "favorites", "pin", "quick" },
    },
    {
      Text = "󰛴  WireGuard vs OpenVPN",
      Subtext = "Why WireGuard is used here",
      Actions = { activate = 'notify-send -t 14000 "WireGuard vs OpenVPN" "WireGuard is a modern VPN protocol: faster, simpler code, and better performance than OpenVPN. It uses state-of-the-art cryptography and reconnects almost instantly. OpenVPN is older, more established, and works through more firewalls. This menu uses WireGuard directly via wg-quick, giving you full control without depending on ProtonVPN\'s CLI or NetworkManager."' },
      Keywords = { "wireguard", "openvpn", "protocol" },
    },
    {
      Text = "󰔟  Interface Name Limit",
      Subtext = "Why config filenames must be short",
      Actions = { activate = 'notify-send -t 12000 "Interface Name Limit" "WireGuard uses the config filename (without .conf) as the network interface name. Linux interface names are limited to 15 characters. If your filename is longer, wg-quick will fail. When downloading from ProtonVPN, rename files before saving:\n  US-East.conf ✓ (7 chars)\n  ProtonVPN_US-AZ-1.conf ✗ (17 chars)"' },
      Keywords = { "interface", "name", "limit", "filename" },
    },
  }
end
