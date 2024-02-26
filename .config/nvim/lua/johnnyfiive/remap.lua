vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cl", "<cmd>lua ColorMyPencils()<CR>")
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move highlighted region up
vim.keymap.set("v", "E", ":m '>+1<CR>gv=gv")
-- move highlighted region down
vim.keymap.set("v", "U", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- remap increment and decrement keys since tmux is using <C-a> as the <prefix> key 
vim.keymap.set("n", "<A-a>", "<C-a>") 
vim.keymap.set("n", "<A-x>", "<C-x>") 

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- clears the search highlighting
vim.keymap.set('n', "<leader>/", "<cmd>noh<CR>")

-- greatest remap ever
-- you have yanked text, but you don't want to lose it.
-- you want to paste it, replace some text, but not lose your original yank.
-- you send whatever was deleted into the void register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
-- yank into the `"+` register, the system clipboard. 
-- now you can paste across multiple instances of vim using `<C-v>`
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- yank complete line onto the system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")

-- new tmux session opening up tmux-sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- query cht.sh
vim.keymap.set("n", "<C-q>", "<cmd>silent !tmux neww cht.sh<CR>")

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make a file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
-- revert making a file executable
vim.keymap.set("n", "<leader>x<Esc>", "<cmd>!chmod -x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/johnnyfiive/packer.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

-- Dismiss Noice Message
vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", {desc = "Dismiss Noice Message"})

-- Source file
vim.keymap.set("n", "<leader><CR>", function()
    vim.cmd("so")
end)

-- Write file
vim.keymap.set("n", "<leader>w", function()
    vim.cmd("w")
end)

-- Quit nvim
vim.keymap.set("n", "<leader>q", function()
    vim.cmd("q")
end)
