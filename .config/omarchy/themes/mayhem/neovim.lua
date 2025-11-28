return {
    {
        "bjarneo/aether.nvim",
        name = "aether",
        priority = 1000,
        opts = {
            disable_italics = false,
            colors = {
                -- Monotone shades (base00-base07)
                base00 = "#000000", -- Default background
                base01 = "#a4a4a4", -- Lighter background (status bars)
                base02 = "#000000", -- Selection background
                base03 = "#a4a4a4", -- Comments, invisibles
                base04 = "#ffffff", -- Dark foreground
                base05 = "#ffffff", -- Default foreground
                base06 = "#ffffff", -- Light foreground
                base07 = "#ffffff", -- Light background

                -- Accent colors (base08-base0F)
                base08 = "#d89695", -- Variables, errors, red
                base09 = "#9c6565", -- Integers, constants, orange
                base0A = "#e7dbaa", -- Classes, types, yellow
                base0B = "#5e8484", -- Strings, green
                base0C = "#e7dcdc", -- Support, regex, cyan
                base0D = "#5e8484", -- Functions, keywords, blue
                base0E = "#d89695", -- Keywords, storage, magenta
                base0F = "#a79d62", -- Deprecated, brown/yellow
            },
        },
        config = function(_, opts)
            require("aether").setup(opts)
            vim.cmd.colorscheme("aether")

            -- Enable hot reload
            require("aether.hotreload").setup()
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "aether",
        },
    },
}
