return {
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    config = function()
      local neocodeium = require("neocodeium")
      local blink = require("blink.cmp")

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          neocodeium.clear()
        end,
      })

      neocodeium.setup({
        filter = function()
          return not blink.is_visible()
        end,
      })

      vim.keymap.set("i", "<A-f>", neocodeium.accept)
    end,
  },
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "default"
          end,
        },
      },
    },
  },
}
