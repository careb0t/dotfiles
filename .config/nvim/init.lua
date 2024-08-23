-- lazy.nvim
require("config.lazy")

-- tab settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- line numbers
vim.opt.relativenumber = true

-- disable text wrap
vim.cmd("set wm=0")

-- keybinds
vim.keymap.set("n", "<leader>t", ":Neotree filesystem reveal left toggle<CR>", {})
