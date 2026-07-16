return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl", -- Use the updated name for the module
  config = function()
    require("ibl").setup({
      indent = {
        char = "│", -- Default character for indent lines
        tab_char = "│",
      },
      scope = {
        enabled = true, -- Highlight scopes (e.g., function blocks)
        show_start = false, -- Show start of scope (optional)
        show_end = false,   -- Show end of scope (optional)
      },
      exclude = {
        filetypes = { "help", "dashboard", "NvimTree" }, -- Filetypes to exclude
        buftypes = { "terminal", "nofile" }, -- Buffer types to exclude
      },
    })
  end,
}
