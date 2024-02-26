function ColorMyPencils()

	color = color or "catppuccin"
	vim.cmd.colorscheme(color)
  -- vim.api.nvim_set_hl(0, "<Group name>", { fg = "<color>", bg = "", italic = false, underline = false, sp = ""})

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) 
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) 
end

ColorMyPencils()



