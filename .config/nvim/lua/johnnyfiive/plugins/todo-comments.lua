return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" }, -- Required dependency
  config = function()
    require("todo-comments").setup({})
  end,
}
