return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x", -- Use the latest stable version of neo-tree
  dependencies = {
    "nvim-lua/plenary.nvim",    -- Required dependency
    "nvim-tree/nvim-web-devicons", -- Optional for icons
    "MunifTanjim/nui.nvim",     -- UI component library
  },
  config = function()
    require("neo-tree").setup({
      window = {
        width = 25,
      },
      filesystem = {
        filtered_items = {
          visible = true,        -- Show filtered items (dimmed out)
          hide_dotfiles = false, -- Show dotfiles
          hide_gitignored = true, -- Hide gitignored files
        },
      },
    })
  end,
}
