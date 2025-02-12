return {
	"nvim-neo-tree/neo-tree.nvim",
  enabled = true,
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {})
		vim.keymap.set("n", "<leader>,", ":Neotree buffers reveal float<CR>", {})
    require("neo-tree").setup({
      window = {
        position = "left",    -- Set window position to left or right (for sidebar)
        width = 40,           -- Adjust the width of the file explorer
        float = {             -- Disable floating window
          enabled = false,    -- Set this to false to prevent floating window for file creation
        },
      },
  })
	end,
}
