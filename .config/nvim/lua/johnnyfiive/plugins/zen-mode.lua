return {
  "folke/zen-mode.nvim",
  config = function()
    require("zen-mode").setup({
      on_open = function(_)
        -- Disable tmux status and zoom the pane
        vim.fn.system([[tmux set status off]])
        vim.fn.system([[tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z]])
      end,
      on_close = function(_)
        -- Re-enable tmux status and unzoom the pane
        vim.fn.system([[tmux set status on]])
        vim.fn.system([[tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z]])
      end,
    })
  end,
}
