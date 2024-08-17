-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = {}

-- color theme:
-- config.color_scheme = 'Everforest Dark Medium (Gogh)'

config.colors = {
		background = "#2d353b",
		cursor_bg = "#d3c6aa",
		cursor_border = "#d3c6aa",
		cursor_fg = "#2d353b",
		foreground = "#d3c6aa",
		ansi = {
		    "#343f44",
		    "#e67e80",
		    "#a7c080",
		    "#dbbc7f",
		    "#7fbbb3",
		    "#d699b6",
		    "#83c092",
			"#d3c6aa",
		},
		brights = {
	        "#5c6a72",
	        "#f85552",
	        "#8da101",
	        "#dfa000",
	        "#3a94c5",
	        "#df69ba",
	        "#35a77c",
	        "#dfddc8",
	    },
	    tab_bar = {
	    	background = "#2D353B",
	    	active_tab = {
	    		bg_color = "#343F44",
	    		fg_color = "#A7C080",
	    	},
	    	inactive_tab = {
	    		bg_color = "#2D353B",
	    		fg_color = "#3A515D",
	    	},
	    	inactive_tab_hover = {
	    		bg_color = "#2D353B",
	    		fg_color = "#7FBBB3",
	    		italic = true,
	    	},
	    	new_tab = {
	    		bg_color = "#2D353B",
	    		fg_color = "#3A515D",
	    	},
	    	new_tab_hover = {
	    		bg_color = "#2D353B",
	    		fg_color = "#7FBBB3",
	     	},
	    },
}

-- tab bar
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- Disable Wayland to allow opening on empty workspace
config.enable_wayland = false

-- and finally, return the configuration to wezterm
return config
