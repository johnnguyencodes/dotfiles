-- set cursor to bar when in insert and command-insert mode
vim.opt.guicursor = "i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150"

-- set number and relative number
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- tabs are 2 spaces
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- word wrap and line break settings
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.linebreak = true

-- spell checking
vim.opt.spell = true
vim.opt.spelllang = {"en_us"}
vim.opt.spellfile = ("%s/spell/spf.%s.add"):format(vim.fn.stdpath("config"), vim.o.encoding)
-- look into using a thesaurus

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true 
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.title = true  -- set terminal window title to something descriptive
vim.opt.inccommand = 'nosplit' -- show incremental changes of commands such as search & replace
vim.opt.virtualedit = 'block' -- virtual editing in visual block mode 

vim.opt.scrolloff = 1 
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
