-- swayimg's defaults use PgUp/PgDn for next/previous image. imv (the other
-- viewer in use here) uses Left/Right instead, so rebind navigation to match
-- and keep muscle memory consistent between the two.
-- PgUp/PgDn still work too since these bindings are added, not swapped in.
swayimg.viewer.on_key("Left", function()
  swayimg.viewer.open("prev")
end)
swayimg.viewer.on_key("Right", function()
  swayimg.viewer.open("next")
end)
