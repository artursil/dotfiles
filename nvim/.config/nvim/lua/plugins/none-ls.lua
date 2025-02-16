return {
    "nvimtools/none-ls.nvim",
    enabled = true,
    dependencies = {
        'nvimtools/none-ls-extras.nvim',
        'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
    },
    config = function()
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting   -- to setup formatters
        local diagnostics = null_ls.builtins.diagnostics -- to setup linters
        -- list of formatters & linters for mason to install
        require('mason-null-ls').setup {
            ensure_installed = {
                'checkmake', -- grammar
                'prettier',  -- ts/js formatter
                'stylua',    -- lua formatter
                'shfmt',     -- bash
                'ruff',
            },
            -- auto-install configured formatters & linters (with null-ls)
            automatic_installation = true,
        }
        local sources = {
            diagnostics.checkmake,
            formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
            formatting.stylua,
            formatting.shfmt.with { args = { '-i', '4' } },
            formatting.terraform_fmt,
            require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } }, --sorting imports
            require('none-ls.formatting.ruff_format'),
        }

        vim.keymap.set("n", "<leader>fo", vim.lsp.buf.format, {})
    end,
}
