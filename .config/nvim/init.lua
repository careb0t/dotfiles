-- lazy.nvim
require("config.lazy")

-- tab settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- line numbers
vim.opt.relativenumber = true

-- keybinds
vim.keymap.set('n', '<leader>t', ':Neotree filesystem reveal left toggle<CR>', {})
