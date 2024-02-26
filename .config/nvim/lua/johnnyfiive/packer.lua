-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'nvim-tree/nvim-web-devicons'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {"catppuccin/nvim", as = "catppuccin"}
  
  -- from theprimeagen's 0 to LSP video
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use{
    'theprimeagen/harpoon', branch = "harpoon2",
    requires = { 
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope.nvim'}
    }
  }
  use('mbbill/undotree')
  use('tpope/vim-fugitive')
  
  -- vim-apm
  use('ThePrimeagen/vim-apm')


  -- tpope's vim plugins
  use('tpope/vim-commentary')
  use('tpope/vim-surround')

  -- nvim-ts-autotag
  use{
    "windwp/nvim-ts-autotag",
    requires = {
      {'nvim-treesitter/nvim-treesitter'}
    }
  }  

  -- indent-blankline.nvim
  use{'lukas-reineke/indent-blankline.nvim', as = 'ibl'}

  -- nvim-notify
  use('rcarriga/nvim-notify')

  -- lsp-zero.nvim
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},
      {'hrsh7th/cmp-cmdline'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }

  -- obsidian.nvim
  use {
    "epwalsh/obsidian.nvim",
    -- recommended, use latest release intead of latest commit
    tag = "*", 
    requires = {
      -- Required.
      {'nvim-lua/plenary.nvim'},
      {'hrsh7th/nvim-cmp'},
      -- optional
      {"nvim-telescope/telescope.nvim"},
      {'nvim-treesitter/nvim-treesitter'},
    },
  }
  
  -- lualine.nvim
  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      { 'nvim-tree/nvim-web-devicons', opt = true },
      { 'meuter/lualine-so-fancy.nvim' },
    },
  }

  -- noice.nvim
  use {
    "folke/noice.nvim",
    event = "VimEnter",
    config = function()
      require("telescope").load_extension("noice")
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help,
        },
        opts = function(_, opts)
          opts.presets = {
            command_palette = {
              views = {
                cmdline_popup = {
                  position = {
                    row = "50%",
                    col = "50%",
                  },
                  size = {
                    min_width = 60,
                    width = "auto",
                    height = "auto",
                  },
                },
                popupmenu = {
                  relative = "editor",
                  position = {
                    row = 23,
                    col = "50%",
                  },
                  size = {
                    width = 60,
                    height = "auto",
                    max_height = 15,
                  },
                  border = {
                    style = "rounded",
                    padding = { 0, 1 },
                  },
                  win_options = {
                    winhighlight = { Normal = "Normal", FloatBorder = "NoiceCmdlinePopupBorder" },
                  },
                },
              },
            },
          }
        end,
      })
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "nvim-telescope/telescope.nvim",
    }
  }
  -- transparent.nvim
  use ('xiyaowong/transparent.nvim')
  
  -- alpha.nvim
  use {
    'goolord/alpha-nvim',
    config = function ()
      require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  }
end)
