return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",                -- Required dependency
    "nvim-telescope/telescope-ui-select.nvim", -- ui-select extension
  },
  config = function()
    local telescope = require("telescope")
    local themes = require("telescope.themes")
    local builtin = require("telescope.builtin")

    -- Setup Telescope
    telescope.setup({
      defaults = {
        file_ignore_patterns = { "node_modules" }, -- Ignore node_modules
        layout_config = {
          horizontal = {
            preview_cutoff = 0, -- Always show preview for horizontal layout
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--sortr=modified" }, -- Use ripgrep to sort files by modified date
        },
      },
      extensions = {
        ["ui-select"] = {
          themes.get_dropdown({}), -- Configure ui-select with dropdown theme
        },
      },
    })

    -- Load Telescope extensions
    telescope.load_extension("ui-select")

    -- Keybindings for Telescope
    vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Find Git-tracked files" })
    vim.keymap.set("n", "<leader>ps", function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end, { desc = "Search for string" })
  end,
}
