-- transparent background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
vim.api.nvim_set_hl(0, "Terminal", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "none" })

-- transparent background for neotree
vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "NeoTreeVertSplit", { bg = "none" })
vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { bg = "none" })
vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none" })

-- transparent lualine

-- set transparent for statusline / lualine groups
local _lualine_hls = {
	"StatusLine",
	"StatusLineNC",
	-- basic lualine groups
	"lualine_a_inactive",
	"lualine_b_command",
	"lualine_b_inactive",
	"lualine_b_insert",
	"lualine_b_normal",
	"lualine_b_replace",
	"lualine_b_visual",
	"lualine_c_normal",
	"lualine_x_normal",
	-- c_13 and c_16 groups
	"lualine_c_13_command","lualine_c_13_inactive","lualine_c_13_insert","lualine_c_13_normal","lualine_c_13_replace","lualine_c_13_terminal","lualine_c_13_visual",
	"lualine_c_16_LV_Bold_command","lualine_c_16_LV_Bold_inactive","lualine_c_16_LV_Bold_insert","lualine_c_16_LV_Bold_normal","lualine_c_16_LV_Bold_replace","lualine_c_16_LV_Bold_terminal","lualine_c_16_LV_Bold_visual",
	-- diagnostics & filetype groups
	"lualine_c_diagnostics_error_command","lualine_c_diagnostics_error_inactive","lualine_c_diagnostics_error_insert","lualine_c_diagnostics_error_normal","lualine_c_diagnostics_error_replace","lualine_c_diagnostics_error_terminal","lualine_c_diagnostics_error_visual",
	"lualine_c_diagnostics_warn_command","lualine_c_diagnostics_warn_inactive","lualine_c_diagnostics_warn_insert","lualine_c_diagnostics_warn_normal","lualine_c_diagnostics_warn_replace","lualine_c_diagnostics_warn_terminal","lualine_c_diagnostics_warn_visual",
	"lualine_c_diagnostics_info_command","lualine_c_diagnostics_info_inactive","lualine_c_diagnostics_info_insert","lualine_c_diagnostics_info_normal","lualine_c_diagnostics_info_replace","lualine_c_diagnostics_info_terminal","lualine_c_diagnostics_info_visual",
	"lualine_c_diagnostics_hint_command","lualine_c_diagnostics_hint_inactive","lualine_c_diagnostics_hint_insert","lualine_c_diagnostics_hint_normal","lualine_c_diagnostics_hint_replace","lualine_c_diagnostics_hint_terminal","lualine_c_diagnostics_hint_visual",
	"lualine_c_filetype_MiniIconsGreen_command","lualine_c_filetype_MiniIconsGreen_inactive","lualine_c_filetype_MiniIconsGreen_insert","lualine_c_filetype_MiniIconsGreen_normal","lualine_c_filetype_MiniIconsGreen_replace","lualine_c_filetype_MiniIconsGreen_terminal","lualine_c_filetype_MiniIconsGreen_visual",
	"lualine_c_filetype_MiniIconsYellow_command","lualine_c_filetype_MiniIconsYellow_inactive","lualine_c_filetype_MiniIconsYellow_insert","lualine_c_filetype_MiniIconsYellow_normal","lualine_c_filetype_MiniIconsYellow_replace","lualine_c_filetype_MiniIconsYellow_terminal","lualine_c_filetype_MiniIconsYellow_visual",
	-- transitional and x/diff groups
	"lualine_transitional_lualine_a_command_to_lualine_b_command","lualine_transitional_lualine_a_normal_to_lualine_b_normal","lualine_transitional_lualine_a_normal_to_lualine_c_normal",
	"lualine_x_3_command","lualine_x_3_inactive","lualine_x_3_insert","lualine_x_3_normal","lualine_x_3_replace","lualine_x_3_terminal","lualine_x_3_visual",
	"lualine_x_4_command","lualine_x_4_inactive","lualine_x_4_insert","lualine_x_4_normal","lualine_x_4_replace","lualine_x_4_terminal","lualine_x_4_visual",
	"lualine_x_5_command","lualine_x_5_inactive","lualine_x_5_insert","lualine_x_5_normal","lualine_x_5_replace","lualine_x_5_terminal","lualine_x_5_visual",
	"lualine_x_6_command","lualine_x_6_inactive","lualine_x_6_insert","lualine_x_6_normal","lualine_x_6_replace","lualine_x_6_terminal","lualine_x_6_visual",
	"lualine_x_diff_added_command","lualine_x_diff_added_inactive","lualine_x_diff_added_insert","lualine_x_diff_added_normal","lualine_x_diff_added_replace","lualine_x_diff_added_terminal","lualine_x_diff_added_visual",
	"lualine_x_diff_modified_command","lualine_x_diff_modified_inactive","lualine_x_diff_modified_insert","lualine_x_diff_modified_normal","lualine_x_diff_modified_replace","lualine_x_diff_modified_terminal","lualine_x_diff_modified_visual",
	"lualine_x_diff_removed_command","lualine_x_diff_removed_inactive","lualine_x_diff_removed_insert","lualine_x_diff_removed_normal","lualine_x_diff_removed_replace","lualine_x_diff_removed_terminal","lualine_x_diff_removed_visual",
	-- misc lualine groups
	"lualine_c_normal","lualine_transparent","lualine_a_normal","lualine_a_insert","lualine_a_visual","lualine_a_command","lualine_a_replace",
	"lualine_c_2_normal","lualine_c_2_insert","lualine_c_2_visual","lualine_c_2_replace","lualine_c_2_command","lualine_c_2_terminal","lualine_c_2_inactive",
	"lualine_c_13_normal","lualine_c_13_insert","lualine_c_13_visual","lualine_c_13_replace","lualine_c_13_command","lualine_c_13_terminal","lualine_c_13_inactive",
}

for _, _name in ipairs(_lualine_hls) do
	pcall(vim.api.nvim_set_hl, 0, _name, { bg = "none" })
end

-- transparent bufferline
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none" })

-- transparent background for nvim-tree
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeVertSplit", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })

-- transparent notify background
vim.api.nvim_set_hl(0, "NotifyINFOBody", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyERRORBody", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyWARNBody", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyTRACEBody", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyINFOTitle", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyERRORTitle", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyWARNTitle", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyTRACETitle", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyINFOBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyERRORBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyWARNBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { bg = "none" })
