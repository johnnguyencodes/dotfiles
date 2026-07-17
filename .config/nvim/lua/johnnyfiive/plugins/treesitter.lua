-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate', -- Automatically update parsers when the plugin is updated
  dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' }, -- Include textobjects module
  config = function()
    require('nvim-treesitter.configs').setup({
      -- Specify languages to be installed. Replace "all" with specific languages if needed
      ensure_installed = "all",
      -- ipkg's release tarball fails to extract (upstream packaging issue,
      -- not a local problem) -- skip it so it doesn't retry-and-fail on
      -- every startup.
      ignore_install = { "ipkg" },

      highlight = { enable = true }, -- Enable syntax highlighting
      indent = { enable = true }, -- Enable Treesitter-based indentation

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<c-backspace>',
        },
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to the text object
          keymaps = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['ii'] = '@conditional.inner',
            ['ai'] = '@conditional.outer',
            ['il'] = '@loop.inner',
            ['al'] = '@loop.outer',
            ['at'] = '@comment.outer',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- Add movements to the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>b'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>B'] = '@parameter.inner',
          },
        },
      },
    })

    -- Workaround: Neovim 0.12 removed the `all` option that
    -- nvim-treesitter's own query_predicates.lua relies on (via
    -- `{ force = true, all = false }`) to receive a single node per
    -- capture. Without it, markdown's "set-lang-from-info-string!"
    -- directive (picks a language for fenced code blocks, e.g. ```bash)
    -- gets a list of nodes instead of one and crashes calling :range() on
    -- the list -- surfaces as a "Decoration provider... attempt to call
    -- method 'range' (a nil value)" error on any markdown buffer with a
    -- fenced code block. Not fixed upstream as of nvim-treesitter's
    -- latest commit; remove this once it is.
    require('nvim-treesitter.query_predicates') -- force their (buggy) registration first
    local query = require('vim.treesitter.query')
    local injection_aliases = { ex = 'elixir', pl = 'perl', sh = 'bash', uxn = 'uxntal', ts = 'typescript' }
    local function lang_from_info_string(alias)
      return vim.filetype.match({ filename = 'a.' .. alias }) or injection_aliases[alias] or alias
    end
    query.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
      local node = match[pred[2]]
      if type(node) == 'table' and not node.range then
        node = node[1] -- unwrap list-of-nodes back to a single node
      end
      if not node then
        return
      end
      metadata['injection.language'] = lang_from_info_string(vim.treesitter.get_node_text(node, bufnr):lower())
    end, { force = true, all = false })
  end,
}
