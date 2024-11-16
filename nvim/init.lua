-- lazy.nvim
require('config.lazy')

-- tab settings
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- line numbers
vim.opt.relativenumber = true

-- disable text wrap
vim.cmd('set wm=0')

-- keybinds
vim.keymap.set('n', '<leader>t', ':Neotree filesystem reveal left toggle<CR>', {})

-- disable mouse
vim.opt.mouse = ''
