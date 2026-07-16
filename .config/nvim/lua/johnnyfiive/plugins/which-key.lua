return {
  "folke/which-key.nvim",
  event = "VeryLazy", -- Load which-key when Neovim starts becoming interactive
  config = function()
    require("which-key").setup({})
  end,
}
