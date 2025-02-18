vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }


-- Normal
keymap("n", "j", "h", opts)
keymap("n", "k", "j", opts)
keymap("n", "l", "k", opts)
keymap("n", ";", "l", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true

-- Copying outsise vim
keymap('v', '<C-c>', ':w !xclip -selection clipboard<CR><CR>', opts)
keymap('v', '<C-S-c>', ':w !xclip -selection clipboard<CR><CR>', opts)
keymap("n", '<C-S-v>', '"+p', opts)




-- Visual --
keymap("v", "j", "h", opts)
keymap("v", "k", "j", opts)
keymap("v", "l", "k", opts)
keymap("v", ";", "l", opts)
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
-- keymap("v", "<A-j>", ":m .+1<CR>==", opts)
-- keymap("v", "<A-l>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts) -- Pastes not the last yanked option if we use visual mode for pasting

