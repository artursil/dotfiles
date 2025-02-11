local M = {}
local opts = { noremap = true, silent = true }

-- Better window navigation
vim.keymap.set("n", "<C-j>", "<C-w>h", opts)
vim.keymap.set("n", "<C-k>", "<C-w>j", opts)
vim.keymap.set("n", "<C-l>", "<C-w>k", opts)
vim.keymap.set("n", "<C-;>", "<C-w>l", opts)

-- Normal --
vim.keymap.set("n", "j", "h", opts)
vim.keymap.set("n", "k", "j", opts)
vim.keymap.set("n", "l", "k", opts)
vim.keymap.set("n", ";", "l", opts)


M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>"}
  }
}

M.dap_python = {
  plugin = true,
  n = {
    ["<leader>dpr"] = {
      function()
        require('dap-python').test_method()
      end
    }
  }
}

return M


