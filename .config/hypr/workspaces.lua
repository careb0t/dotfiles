-- Global workspaces: opt out of Omarchy 4.5's per-monitor workspaces.
--
-- Omarchy 4.5 gives each monitor its own block of ten workspaces (DP-1 = 1-10,
-- HDMI-A-1 = 11-20), so SUPER+1 on the right monitor went to workspace 11
-- instead of workspace 1 on the left one, and reconcile renumbered existing
-- workspaces into those blocks. That defeats the workspace -> monitor pins in
-- monitors.lua. This file restores classic global numbering:
--   * SUPER+N always goes to workspace N, on whatever monitor it's pinned to.
--   * Omarchy's reconcile (which renumbers workspaces into per-monitor blocks)
--     is replaced with a no-op that just tells the bar every monitor shares
--     block 0, so each bar shows the global 1-10 row like before.
-- See $OMARCHY_PATH/default/hypr/monitor-workspaces.lua for what's overridden.

local paths = require("default.hypr.paths")
local ws = o.workspaces

-- The bar (Workspaces.qml) reads connector -> block from this file. Put every
-- monitor in block 0 so all bars show workspaces 1-10.
local function write_bar_state()
  local lines = {}
  for _, monitor in ipairs(hl.get_monitors()) do
    lines[#lines + 1] = "0\t" .. monitor.name .. "\t" .. monitor.name .. "\n"
  end
  local file = io.open(paths.state_home .. "/omarchy/monitor-workspaces", "w")
  if file then
    file:write(table.concat(lines))
    file:close()
  end
end

-- Omarchy's start/reload/monitor hooks call ws.reconcile at event time, so
-- replacing it here disables the renumbering.
ws.reconcile = function()
  write_bar_state()
end
write_bar_state()

-- Clicking a workspace in the bar dispatches o.workspaces.focus(slot, monitor).
-- Make that a plain global focus.
ws.focus = function(slot)
  local id = tostring(slot)
  local fn = function()
    hl.dispatch(hl.dsp.focus({ workspace = id }))
  end
  o.bind_expressions[fn] = "o.workspaces.focus(" .. slot .. ")"
  return fn
end

for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  local id = tostring(workspace)
  o.rebind("SUPER + " .. key, "Switch to workspace " .. workspace, hl.dsp.focus({ workspace = id }))
  o.rebind("SUPER + SHIFT + " .. key, "Move window to workspace " .. workspace,
    hl.dsp.window.move({ workspace = id }))
  o.rebind("SUPER + SHIFT + ALT + " .. key, "Move window silently to workspace " .. workspace,
    hl.dsp.window.move({ workspace = id, follow = false }))
end

-- Moving a workspace to another monitor: plain move, no renumbering.
for dir, name in pairs({ l = "left", r = "right", u = "up", d = "down" }) do
  local key = ({ l = "LEFT", r = "RIGHT", u = "UP", d = "DOWN" })[dir]
  o.rebind("SUPER + SHIFT + ALT + " .. key, "Move workspace to " .. name .. " monitor", function()
    local target = hl.get_monitor(dir)
    if target then
      hl.dispatch(hl.dsp.workspace.move({ monitor = target.name }))
    end
  end)
end
