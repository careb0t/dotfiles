return {
	"gbprod/nord.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		-- Optionally configure and load the colorscheme
		-- directly inside the plugin declaration.
    require("nord").setup({})
		vim.cmd.colorscheme("nord")
	end,
}
