return {
    {
        "bjarneo/aether.nvim",
        branch = "v2",
        name = "aether",
        priority = 1000,
        opts = {
            transparent = false,
            colors = {
                -- Background colors
                bg = "#000000",
                bg_dark = "#000000",
                bg_highlight = "#a4a4a4",

                -- Foreground colors
                -- fg: Object properties, builtin types, builtin variables, member access, default text
                fg = "#ffffff",
                -- fg_dark: Inactive elements, statusline, secondary text
                fg_dark = "#ffffff",
                -- comment: Line highlight, gutter elements, disabled states
                comment = "#a4a4a4",

                -- Accent colors
                -- red: Errors, diagnostics, tags, deletions, breakpoints
                red = "#d89695",
                -- orange: Constants, numbers, current line number, git modifications
                orange = "#9c6565",
                -- yellow: Types, classes, constructors, warnings, numbers, booleans
                yellow = "#e7dbaa",
                -- green: Comments, strings, success states, git additions
                green = "#5e8484",
                -- cyan: Parameters, regex, preprocessor, hints, properties
                cyan = "#e7dcdc",
                -- blue: Functions, keywords, directories, links, info diagnostics
                blue = "#5e8484",
                -- purple: Storage keywords, special keywords, identifiers, namespaces
                purple = "#d89695",
                -- magenta: Function declarations, exception handling, tags
                magenta = "#9c6565",
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
