return {
    'nvimtools/none-ls.nvim',
    dependencies = {
        'nvimtools/none-ls-extras.nvim',
    },
    config = function()
        local null_ls = require('null-ls')
        null_ls.setup({
            sources = {
                -- null_ls.builtins.formatting.stylua,
                null_ls.builtins.diagnostics.erb_lint,
                null_ls.builtins.diagnostics.rubocop,
                null_ls.builtins.formatting.rubocop,
                null_ls.builtins.formatting.black,
                require('none-ls.formatting.eslint_d'),
                require('none-ls.diagnostics.eslint_d'),
                require('none-ls.code_actions.eslint_d')
            },
        })

        vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, { desc = 'format file with LSP' })
    end,
}
