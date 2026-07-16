return {
  "xiyaowong/transparent.nvim",
  config = function()
    require("transparent").setup({
      extra_groups = {
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NormalFloat",
        "Neotree",
        "FloatBorder",
        "FloatTitle",
      },
    })
  end,
}
