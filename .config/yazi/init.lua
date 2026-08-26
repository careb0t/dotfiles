function Entity:icon()
  local icon = th.icon:match(self._file, { hovered = self._file.is_hovered })
  if not icon then
    return ""
  else
    return icon.text .. " "
  end
end
