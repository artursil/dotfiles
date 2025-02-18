return {
    'numToStr/Comment.nvim',
    opts = {
        padding = true,
        sticky = true,
        toggler = {
            line = '<C-_>',  -- Works in tmux
            block = '<C-?>',
        },
        opleader = {
            line = '<C-_>',  -- Works in tmux
            block = '<C-?>',
        },
        mappings = {
            basic = true,
            extra = true,
        }
    },
    config = function()
        require('Comment').setup()

        -- Ensure compatibility in both tmux and normal terminal
        vim.api.nvim_set_keymap('n', '<C-/>', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('v', '<C-/>', '<esc><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', { noremap = true, silent = true })

        -- Also explicitly map <C-_> for tmux
        vim.api.nvim_set_keymap('n', '<C-_>', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('v', '<C-_>', '<esc><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', { noremap = true, silent = true })
    end
}
