Name = "vpn"
NamePretty = "ProtonVPN"
HideFromProviderlist = false
FixedOrder = true
Cache = false

local HOME = os.getenv("HOME")
local CONF_DIR = HOME .. "/.config/protonvpn/wireguard"

local COUNTRY_NAMES = {
  AD="Andorra", AE="UAE", AL="Albania", AM="Armenia", AR="Argentina",
  AT="Austria", AU="Australia", AZ="Azerbaijan", BA="Bosnia", BE="Belgium",
  BG="Bulgaria", BR="Brazil", BY="Belarus", CA="Canada", CH="Switzerland",
  CL="Chile", CO="Colombia", CR="Costa Rica", CY="Cyprus", CZ="Czech Republic",
  DE="Germany", DK="Denmark", EE="Estonia", EG="Egypt", ES="Spain",
  FI="Finland", FR="France", GB="United Kingdom", GE="Georgia", GH="Ghana",
  GR="Greece", HK="Hong Kong", HR="Croatia", HU="Hungary", ID="Indonesia",
  IE="Ireland", IL="Israel", IN="India", IS="Iceland", IT="Italy",
  JP="Japan", KE="Kenya", KG="Kyrgyzstan", KH="Cambodia", KR="South Korea",
  KZ="Kazakhstan", LT="Lithuania", LU="Luxembourg", LV="Latvia", MD="Moldova",
  ME="Montenegro", MK="North Macedonia", MX="Mexico", MY="Malaysia",
  NG="Nigeria", NL="Netherlands", NO="Norway", NZ="New Zealand", PA="Panama",
  PE="Peru", PH="Philippines", PK="Pakistan", PL="Poland", PR="Puerto Rico",
  PT="Portugal", RO="Romania", RS="Serbia", SE="Sweden", SG="Singapore",
  SI="Slovenia", SK="Slovakia", TH="Thailand", TN="Tunisia", TR="Turkey",
  TW="Taiwan", UA="Ukraine", US="United States", UZ="Uzbekistan",
  VN="Vietnam", ZA="South Africa",
}

local function ShellEscape(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function display_name(filename)
  local base = filename:gsub("^ProtonVPN_", "")
  local code, rest = base:match("^(%u%u)%-(.+)$")
  if not code then code = base:match("^(%u%u)$") end
  local country = (code and (COUNTRY_NAMES[code] or code)) or base
  if not rest then return country end
  if rest:match("^%d+$") then return country .. " #" .. rest end
  return country .. " (" .. rest:gsub("[_%-]+", " ") .. ")"
end

local function get_servers()
  local handle = io.popen("find " .. ShellEscape(CONF_DIR) .. " -maxdepth 1 -name '*.conf' 2>/dev/null | sort")
  if not handle then return {} end
  local servers = {}
  for path in handle:lines() do
    local filename = path:match("([^/]+)$")
    if filename then
      local name = filename:gsub("%.conf$", "")
      servers[#servers + 1] = { path = path, name = name, label = display_name(name) }
    end
  end
  handle:close()
  return servers
end

function GetEntries()
  local servers = get_servers()

  if #servers == 0 then
    return {
      {
        Text = "󰋗  No servers configured",
        Subtext = "Add .conf files to " .. CONF_DIR,
        Actions = { activate = HOME .. "/.local/bin/vpn-setup" },
      },
    }
  end

  local entries = {}
  for _, s in ipairs(servers) do
    entries[#entries + 1] = {
      Text = "󰖟  " .. s.label,
      Subtext = s.name,
      Keywords = { s.label, s.name },
      Actions = { activate = "vpn-connect " .. ShellEscape(s.path) },
    }
  end

  entries[#entries + 1] = {
    Text = "󰅚  Disconnect",
    Subtext = "Disconnect from ProtonVPN",
    Actions = { activate = "vpn-disconnect" },
    Keywords = { "disconnect", "stop" },
  }
  entries[#entries + 1] = {
    Text = "󰇙  More",
    Subtext = "Status, setup, help",
    Actions = { activate = "walker -m menus:vpnMore --maxheight 800" },
    Keywords = { "more", "status", "help", "settings" },
  }

  return entries
end
