return {
    'smoka7/hop.nvim',
    version = "*",
    opts = {
        keys = 'etovxqpdygfblzhckisuran'
    },
    config = function()
        local hop = require('hop')
        hop.setup()
        local directions = require('hop.hint').HintDirection

        vim.api.nvim_set_keymap('n', '<leader><leader>w', "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader><leader>b', "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<CR>", { noremap = true, silent = true })
    end

}

