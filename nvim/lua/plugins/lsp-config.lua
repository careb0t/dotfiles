return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup({
                ui = {
                    icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                    },
                },
            })
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({ capabilities = capabilities })
			lspconfig.ts_ls.setup({ capabilities = capabilities })
			--lspconfig.cssls.setup({ capabilities = capabilities })
			--lspconfig.eslint_d.setup({ capabilities = capabilities })
			lspconfig.jsonls.setup({ capabilities = capabilities })
			--lspconfig.html.setup({ capabilities = capabilities })
			lspconfig.sqls.setup({ capabilities = capabilities })
			lspconfig.vuels.setup({ capabilities = capabilities })
			lspconfig.yamlls.setup({ capabilities = capabilities })
			lspconfig.bashls.setup({ capabilities = capabilities })
			lspconfig.jinja_lsp.setup({ capabilities = capabilities })
			--lspconfig.emmet_language_server.setup({ capabilities = capabilities })
            lspconfig.pyright.setup({ capabilities = capabilities })
            lspconfig.ruff.setup({ capabilities = capabilities })
            lspconfig.svelte.setup({ capabilities = capabilities })

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "get LSP definition" })
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "get LSP references" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "code action" })
		end,
	},
}
