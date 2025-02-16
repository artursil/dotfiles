return {
    'numToStr/Comment.nvim',
    opts = {
        ---Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        toggler = {
        ---Lines to be ignored while (un)comment
            ---Line-comment toggle keymap
            line = '<C-/>',  -- Change `gcc` to `<C-/>`
            ---Block-comment toggle keymap
            block = '<C-?>', -- Change `gbc` to `<C-?>` (or another key if `<C-/>` fails)
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            ---Line-comment keymap
            line = '<C-/>',  -- Change `gc` to `<C-/>`
            ---Block-comment keymap
            block = '<C-?>', -- Change `gb` to `<C-?>`
        },
        ---Enable keybindings
        mappings = {
            basic = true, -- Enables the operator-pending and toggler mappings
            extra = true, -- Enables extra mappings
        }
    }
}
