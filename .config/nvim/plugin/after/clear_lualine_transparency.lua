-- helper to clear lualine-generated highlights using the `transparent` plugin
local function clear_lualine_transparency()
  local ok, transparent = pcall(require, "transparent")
  if not ok or type(transparent.clear_prefix) ~= "function" then
    return
  end
  pcall(transparent.clear_prefix, "lualine")
end

-- run immediately and deferred
clear_lualine_transparency()
vim.defer_fn(clear_lualine_transparency, 50)

-- re-run on ColorScheme and VimEnter to handle reapplication
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  callback = function()
    vim.defer_fn(clear_lualine_transparency, 50)
  end,
})
