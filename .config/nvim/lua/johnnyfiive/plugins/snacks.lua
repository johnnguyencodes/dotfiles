return {
  'folke/snacks.nvim',
  priority = 1000,
  dependencies = { 'nvim-lua/plenary.nvim' },  -- Dependencies
  config = function()
    -- Plugin Setup
    require('snacks').setup{
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      indent = { enabled = false },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          -- wo = { wrap = true } -- Wrap notifications
        }
      }
    }

    -- Define keybindings
    local Snacks = require('snacks')

    -- Mapping utility for multiple modes
    local function map(modes, lhs, rhs, desc)
      vim.keymap.set(modes, lhs, rhs, { desc = desc, silent = true })
    end

    -- Define keybindings as per the 'keys' table
    map("n", "<leader>z",  function() Snacks.zen() end, "Toggle Zen Mode")
    map("n", "<leader>Z",  function() Snacks.zen.zoom() end, "Toggle Zoom")
    map("n", "<leader>.",  function() Snacks.scratch() end, "Toggle Scratch Buffer")
    map("n", "<leader>S",  function() Snacks.scratch.select() end, "Select Scratch Buffer")
    map("n", "<leader>n",  function() Snacks.notifier.show_history() end, "Notification History")
    map("n", "<leader>bd", function() Snacks.bufdelete() end, "Delete Buffer")
    map("n", "<leader>cR", function() Snacks.rename.rename_file() end, "Rename File")
    map("n", "<leader>gB", function() Snacks.gitbrowse() end, "Git Browse")
    map("n", "<leader>gb", function() Snacks.git.blame_line() end, "Git Blame Line")
    map("n", "<leader>gf", function() Snacks.lazygit.log_file() end, "Lazygit Current File History")
    map("n", "<leader>gg", function() Snacks.lazygit() end, "Lazygit")
    map("n", "<leader>gl", function() Snacks.lazygit.log() end, "Lazygit Log (cwd)")
    map("n", "<leader>un", function() Snacks.notifier.hide() end, "Dismiss All Notifications")
    map("n", "<c-/>",      function() Snacks.terminal() end, "Toggle Terminal")
    map("n", "<c-_>",      function() Snacks.terminal() end, "Toggle Terminal")  -- 'which_key_ignore' typically handled differently
    map({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, "Next Reference")
    map({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, "Prev Reference")
    map("n", "<leader>N", function()
      Snacks.win({
        file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
        width = 0.9,
        height = 0.9,
        wo = {
          spell = false,
          wrap = false,
          signcolumn = "yes",
          statuscolumn = " ",
          conceallevel = 3,
        },
      })
    end, "Neovim News")
  end,

  -- Lazy.nvim's `init` runs before the plugin is loaded
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        local Snacks = require('snacks')

        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
}
