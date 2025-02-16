return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fu", builtin.oldfiles, {})
      vim.keymap.set("n", "<leader>fa", function()
        local python_site_packages = vim.fn.systemlist("python3 -c 'import site; print(site.getsitepackages()[0])'")[1]
        require("telescope.builtin").live_grep({
          -- additional_args = function()
          --   return {
          --     "--regexp", '"(def|class) '  -- Search for "def " or "class " inside JSON strings
          --   }
          -- end,
          search_dirs = { ".", python_site_packages }
        })
      end, { noremap = true, silent = true })

      require("telescope").load_extension("ui-select")
    end,
  },
}
