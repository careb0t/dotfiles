return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				window = {
					width = 30,
				},
				filesystem = {
					filtered_items = {
						--visible = true,
						hide_dotfiles = false,
						hide_gitignored = true,
						hide_by_name = {
							".github",
							".gitignore",
							"package-lock.json",
						},
						never_show = { ".git" },
					},
				},
			})
		end,
	},
}
