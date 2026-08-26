return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg = "{{ background }}",
        dark_bg = "{{ dark_background }}",
        darker_bg = "{{ darker_background }}",
        lighter_bg = "{{ lighter_background }}",

        fg = "{{ foreground }}",
        dark_fg = "{{ dark_foreground }}",
        light_fg = "{{ light_foreground }}",
        bright_fg = "{{ bright_foreground }}",
        muted = "{{ muted }}",

        -- Omarchy's colors.toml has no dedicated "highlight" color, but
        -- aether.nvim uses bg_highlight for cursor-word/LSP-reference
        -- highlighting, CursorColumn, Telescope selection, Flash matches,
        -- etc. Left unset, it falls back to aether.nvim's hardcoded
        -- #000000 default, which is unreadable on dark themes. `muted` is
        -- the closest semantic fit across every Omarchy theme.
        bg_highlight = "{{ muted }}",

        red = "{{ red }}",
        yellow = "{{ yellow }}",
        orange = "{{ orange }}",
        green = "{{ green }}",
        cyan = "{{ cyan }}",
        blue = "{{ blue }}",
        magenta = "{{ magenta }}",
        brown = "{{ brown }}",

        bright_red = "{{ bright_red }}",
        bright_yellow = "{{ bright_yellow }}",
        bright_green = "{{ bright_green }}",
        bright_cyan = "{{ bright_cyan }}",
        bright_blue = "{{ bright_blue }}",
        bright_magenta = "{{ bright_magenta }}",

        accent = "{{ accent }}",
        cursor = "{{ bright_foreground }}",
        foreground = "{{ foreground }}",
        background = "{{ background }}",
        selection = "{{ selection }}",
        selection_foreground = "{{ selection_foreground }}",
        selection_background = "{{ selection_background }}",
      },
      -- aether.nvim's own LspReferenceRead group leaks a stale `fg = bg`
      -- from an earlier merge step it doesn't clear, making "read"
      -- references of the word under the cursor render as invisible
      -- near-background text. Match it to LspReferenceText/Write, which
      -- don't have this bug.
      on_highlights = function(hl, c)
        hl.LspReferenceRead = { bg = c.bg_highlight }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
