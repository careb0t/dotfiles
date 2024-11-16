return {
	"3rd/image.nvim",
  dependencies = {
    "kiyoon/magick.nvim"
  },
	config = function()
		require("image").setup({
            -- config goes here
		})
	end,
}
