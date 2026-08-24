-- When swayimg is launched on a single file, it only loads that one file
-- (imagelist.size == 1), so there's nothing for Left/Right to move to. This
-- pulls in the rest of that file's directory so navigation always has
-- something to cycle through, e.g. `swayimg ride.gif` still lets you page
-- through every other image in the same folder.
swayimg.imagelist.adjacent = true

-- `adjacent` above adds every file in the directory, not just images, so
-- Left/Right could otherwise land on a .txt or .nfo and just error out.
-- Strip anything whose extension isn't in swayimg's compiled-in format list
-- (see `swayimg --version`) once the image list has actually been built.
local supported_ext = {
  png = true, jpg = true, jpeg = true, webp = true, jxl = true,
  avif = true, heif = true, heic = true, gif = true, tiff = true,
  tif = true, svg = true, jp2 = true, j2k = true, exr = true,
  xbm = true, qoi = true, pnm = true, pgm = true, ppm = true,
  pbm = true, farbfeld = true, ff = true, dicom = true, dcm = true,
  bmp = true, tga = true,
}
swayimg.on_initialized(function()
  local unsupported = {}
  for _, entry in ipairs(swayimg.imagelist.get()) do
    local ext = entry.path:match("%.([^.]+)$")
    if not (ext and supported_ext[ext:lower()]) then
      table.insert(unsupported, entry.path)
    end
  end
  if #unsupported > 0 then
    swayimg.imagelist.remove(unsupported)
  end
end)

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

-- q closes the window (same as Escape), matching the common "quit" muscle
-- memory from other viewers/pagers.
swayimg.viewer.on_key("q", function()
  swayimg.exit()
end)
swayimg.gallery.on_key("q", function()
  swayimg.exit()
end)
