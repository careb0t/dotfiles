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
            on_highlights = function(hl, c)
                -- Comments: use the designated grey instead of teal
                hl.Comment = { fg = c.comment, italic = true }
                hl.SpecialComment = { fg = c.comment, italic = true }
                hl["@comment"] = { link = "Comment" }
                hl["@comment.error"]   = { fg = c.error }
                hl["@comment.warning"] = { fg = c.warning }
                hl["@comment.hint"]    = { fg = c.hint }
                hl["@comment.info"]    = { fg = c.info }
                hl["@comment.note"]    = { fg = c.hint }
                hl["@comment.todo"]    = { fg = c.todo }

                -- Functions: bold rose/pink to stand apart from teal strings
                hl.Function = { fg = c.red, bold = true }
                hl["@function"]             = { link = "Function" }
                hl["@function.call"]        = { fg = c.red }
                hl["@function.method"]      = { fg = c.red }
                hl["@function.method.call"] = { fg = c.red }
                hl["@function.builtin"]     = { fg = c.red }

                -- Properties: light pinkish-white to contrast string values
                -- (covers JSON keys, JS/TS object members, Lua table fields, etc.)
                hl["@property"] = { fg = c.cyan }
                hl["@lsp.type.property"] = { fg = c.cyan }

                -- Parameters: warm cream so they differ from plain variables
                -- Both treesitter and LSP semantic token variants needed
                hl["@variable.parameter"] = { fg = c.yellow }
                hl["@lsp.type.parameter"] = { fg = c.yellow }

                -- LSP function/method tokens: keep consistent with treesitter overrides
                hl["@lsp.type.function"] = { link = "Function" }
                hl["@lsp.type.method"]   = { link = "Function" }
            end,
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
