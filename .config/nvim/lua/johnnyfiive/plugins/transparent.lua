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
        -- Telescope's own groups link to NormalFloat/FloatBorder already,
        -- but it lazy-loads well after the initial transparency pass runs
        -- at startup -- listing these explicitly avoids depending on that
        -- link surviving whatever Telescope/catppuccin's integration sets
        -- up when it finally loads. Border groups deliberately excluded
        -- so the picker's outline stays visible against a transparent fill.
        "TelescopeNormal",
        "TelescopePromptNormal",
        "TelescopeResultsNormal",
        "TelescopePreviewNormal",
      },
    })
  end,
}
