-- NOTE Prettier Configuration
vim.g['prettier#autoformat'] = 1
vim.g['prettier#autoformat_require_pragma'] = 0

-- Toggle Color Scheme
vim.keymap.set("n", "<leader>cl", "<cmd>lua ColorMyPencils()<CR>", { desc = "Toggle Color Scheme" })

-- Open Ex File Explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open File Explorer" })

-- NOTE Moving Highlighted Text
-- Move highlighted region up
vim.keymap.set("v", "E", ":m '>+1<CR>gv=gv", { desc = "Move Sel Down" })
-- Move highlighted region down
vim.keymap.set("v", "U", ":m '<-2<CR>gv=gv", { desc = "Move Sel Up" })

-- NOTE Enhanced Navigation
-- Join lines without moving cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join Lines Without Moving Cursor" })
-- Scroll down and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down and Center" })
-- Scroll up and center
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up and Center" })
-- Search next and center
vim.keymap.set("n", "n", "nzzzv", { desc = "Next Search Result and Center" })
-- Search previous and center
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev Search Result and Center" })

-- NOTE Increment/Decrement
-- Increment
vim.keymap.set("n", "<A-a>", "<C-a>", { desc = "++ Number" })
-- Decrement
vim.keymap.set("n", "<A-x>", "<C-x>", { desc = "-- Number" })

-- Clear Search Highlighting
vim.keymap.set('n', "<leader>/", "<cmd>noh<CR>", { desc = "Clear Search Highlighting" })

-- Paste without overwriting register
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste Without Overwriting Register" })

-- NOTE System Clipboard Operations
-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to System Clipboard" })
-- Yank entire line to system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank Entire Line to System Clipboard" })
-- Delete without affecting registers
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete Without Affecting Registers" })

-- Disable the `Q` key in normal mode
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Q Key" })

-- Open Tmux Sessionizer in new Tmux window
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Open Tmux Sessionizer" })

-- Query cht.sh in new Tmux window
vim.keymap.set("n", "<C-q>", "<cmd>silent !tmux neww cht.sh<CR>", { desc = "Query cht.sh" })

-- Format code using LSP
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Code with LSP" })

-- NOTE Quickfix and Location List Navigation
-- Navigate to next item in quickfix list and center
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next Quickfix Item" })
-- Navigate to previous item in quickfix list and center
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Prev Quickfix Item" })
-- Navigate to next item in location list and center
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next Location List Item" })
-- Navigate to previous item in location list and center
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Prev Location List Item" })

-- Search and replace the word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search & Replace Word Under Cursor" })

-- NOTE Make/Revert File Executable
-- Make the current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make File Executable", silent = true })
-- Revert making the current file executable
vim.keymap.set("n", "<leader>x<Esc>", "<cmd>!chmod -x %<CR>", { desc = "Revert File Executable", silent = true })

-- Open plugins.lua configuration file
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/johnnyfiive/plugins.lua<CR>", { desc = "Open plugins.lua" })

-- Neotree reveal current file
vim.keymap.set("n", "<leader>fr", ":Neotree reveal<CR>", { desc = "Reveal Current File in Neotree" })

-- Dismiss Noice Message
vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Message" })

-- vim fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- NOTE Source, Write, Quit File
-- Source the current file
vim.keymap.set("n", "<leader><CR>", function()
    vim.cmd("so")
end, { desc = "Source Current File" })

-- Write (save) the current file
vim.keymap.set("n", "<leader>w", function()
    vim.cmd("w")
end, { desc = "Save Current File" })

-- Open a vertical split
vim.keymap.set("n", "<leader>v", function()
    vim.cmd("vsp")
end, { desc = "Open a vertical split"}
)

-- Quit Neovim
vim.keymap.set("n", "<leader>q", function()
    vim.cmd("q")
end, { desc = "Quit Neovim" })

-- Obsidian Live Grep
vim.keymap.set('n', '<leader>os', ":ObsidianSearch<CR>", { desc = "Obsidian Search Vault" })

-- Obsidian show back links
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Obsidian Show Backlinks" })

-- Obsidian search tags
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTags<cr>", { desc = "Obsidian Search Tags" })

-- Obsidian create new note
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "Obsidian New Note" })

-- Obsidian create today's note
vim.keymap.set("n", "<leader>od", "<cmd>ObsidianToday<cr>", { desc = "Obsidian Today's Note" })

-- Obsidian insert template
vim.keymap.set("n", "<leader>oi", "<cmd>ObsidianTemplate<cr>", { desc = "Obsidian Insert Template" })

-- Obsidian rename note
vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<cr>", { desc = "Obsidian Rename Note" })

-- Obsidian link highlighted text
vim.keymap.set("v", "<leader>ol", ":ObsidianLink<cr>", { desc = "Link Selection" })

-- Obsidian extract highlighted text to new note
vim.keymap.set("v", "<leader>oe", ":ObsidianExtractNote<cr>", { desc = "Extract Note" })

-- Obsidian open note in Obsidian app
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Open in Obsidian App" })
