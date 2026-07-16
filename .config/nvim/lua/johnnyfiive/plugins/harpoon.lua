return {
  "theprimeagen/harpoon",
  config = function()
    -- Import required Harpoon modules
    local harpoon = require("harpoon")

    -- REQUIRED setup for Harpoon
    harpoon:setup()

    -- Keymaps for Harpoon
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Add file to Harpoon list" })
    vim.keymap.set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle Harpoon quick menu" })

    -- Keymaps for selecting files in the Harpoon list
    for i = 1, 9 do
      vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end, { desc = "Navigate to Harpoon file " .. i })
    end
    vim.keymap.set("n", "<leader>0", function() harpoon:list():select(10) end, { desc = "Navigate to Harpoon file 10" })

    -- Keymaps for toggling previous and next buffers in the Harpoon list
    vim.keymap.set("n", "<C-S-P>", function() harpoon.ui.nav_prev() end, { desc = "Navigate to previous Harpoon file" })
    vim.keymap.set("n", "<C-S-N>", function() harpoon.ui.nav_next() end, { desc = "Navigate to next Harpoon file" })

  end,
}
