return {
  -- Lazy can manage itself
  { 'folke/lazy.nvim' },

  -- Nvim-web-devicons
  { 'nvim-tree/nvim-web-devicons' },

  { 'nvim-lua/plenary.nvim'},

  -- Catppuccin theme
  { 'catppuccin/nvim', name = 'catppuccin' },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },

  -- Harpoon
  {
    'theprimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    lazy = false,
  },

  -- Undo tree
  { 'mbbill/undotree' },

  -- Vim-fugitive
  { 'tpope/vim-fugitive' },

  -- TypeScript tools
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  },

  -- Todo comments
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Which-key
  { 'folke/which-key.nvim' },

  -- Snacks.nvim
  { 'folke/snacks.nvim' },

  -- Prettier
  { 'prettier/vim-prettier' },

  -- Emmet-vim
  { 'mattn/emmet-vim' },

  -- Tpope's plugins
  { 'tpope/vim-commentary' },
  { 'tpope/vim-surround' },

  -- Nvim-autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  },

  -- Nvim-ts-autotag: auto-closes JSX/HTML tags as you type (e.g. typing
  -- `>` after `<div` immediately inserts `</div>`). Was listed as a
  -- dependency but never had `.setup()` called, so it was never actually
  -- active -- confirmed via testing that it changes the JSX typing
  -- pattern enough to fix indent-while-typing (see treesitter.lua note).
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },

  -- Vim-visual-multi
  { 'mg979/vim-visual-multi' },

  -- highlight hex colors
  { 'brenoprata10/nvim-highlight-colors' },

  -- Zen-mode and Twilight
  { 'folke/zen-mode.nvim' },
  { 'folke/twilight.nvim' },

  -- Indent-blankline.nvim
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      {
        enabled = true,
        show_start = true,
        show_end = false,
        injected_languages = false,
        highlight = { "Function", "Label" },
        priority = 500,
      }
    },
  },
  -- Mini.nvim (bundles mini.ai and mini.icons in one repo)
  {
    'echasnovski/mini.nvim',
    branch = 'stable',
    config = function()
      require('mini.icons').setup()
      require('mini.ai').setup {}
    end,
  },

  -- LuaSnip
  {
    'L3MON4D3/LuaSnip',
    tag = 'v2.*',
    build = 'make install_jsregexp',
  },

  -- Telescope UI Select
  { 'nvim-telescope/telescope-ui-select.nvim' },

  -- Obsidian.nvim
  {
    'epwalsh/obsidian.nvim',
    tag = '*',
    ft = "markdown",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
      'nvim-telescope/telescope.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },

  -- Lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', optional = true },
      { 'meuter/lualine-so-fancy.nvim' },
    },
  },

  -- Neo-tree
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
  },

  -- Noice.nvim
  {
    'folke/noice.nvim',
    event = 'VimEnter',
    config = function()
      require('telescope').load_extension('noice')
      require('noice').setup({
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        presets = {
          bottom_search = false,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
      })
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
      'nvim-telescope/telescope.nvim',
    },
  },

  -- Transparent.nvim
  { 'xiyaowong/transparent.nvim' },

  -- Alpha.nvim
  {
    'goolord/alpha-nvim',
    config = function()
      require('alpha').setup(require('alpha.themes.dashboard').config)
    end,
  },


    -- arduino-language-server quality-of-life plugins
    {
    "stevearc/vim-arduino",
    ft = "arduino",
    config = function()
      -- keymaps for compiling and uploading
        vim.keymap.set('n', '<leader>ac', '<cmd>ArduinoVerify<CR>', { desc = "Compile Sketch" })
        vim.keymap.set('n', '<leader>au', '<cmd>ArduinoUpload<CR>', { desc = "Upload Sketch" })
        vim.keymap.set('n', '<leader>as', '<cmd>ArduinoSerialStart<CR>', { desc = "Start Serial Monitor" })
        vim.keymap.set('n', '<leader>ab', '<cmd>ArduinoChooseBoard<CR>', { desc = "Select Board" })
    end
  },
}
