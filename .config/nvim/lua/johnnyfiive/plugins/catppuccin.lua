return {
  "catppuccin/nvim",
  name = "catppuccin", -- Specify the name for lazy.nvim
  priority = 10000, -- Load this colorscheme first
  opts = {
    flavour = "mocha",
    color_overrides = {
      all = {
        green = "#ffffff",
      }
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
      enabled = false, -- dims the background color of inactive window
      shade = "dark",
      percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
      comments = { "italic" },
      properties = {},
      functions = { "bold" },
      keywords = { "bold" },
      operators = {},
      conditionals = { "italic", "bold" },
      loops = { "italic" },
      booleans = { "italic" },
      numbers = {},
      types = { "bold" },
      strings = {},
      variables = {"italic"},
    },
    custom_highlights = {},
    default_integrations = true,
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = false,
      neotree = true,
      alpha = true,
      mini = {
        enabled = true,
        indentscope_color = "",
      },
    }
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)

    -- Global toggle used by `<leader>cl` and the VimEnter autocmd in init.lua
    -- to (re)apply the colorscheme, e.g. after a terminal color glitch.
    _G.ColorMyPencils = function()
      vim.cmd.colorscheme("catppuccin")
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end

    ColorMyPencils()
  end,
}

