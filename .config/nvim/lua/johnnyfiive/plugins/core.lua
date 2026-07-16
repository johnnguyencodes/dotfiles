return {
  "nvim-lua/plenary.nvim", -- Use a minimal plugin as a placeholder
  lazy = false,            -- Ensure this runs immediately during startup
  priority = 1000,         -- Load this before other plugins
  config = function()
    -- Set conceallevel globally
    vim.opt.conceallevel = 2
  end,
}
