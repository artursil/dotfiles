return {
  {
    "kiyoon/jupynium.nvim",
    -- build = "pip3 install --user .",
    -- build = "conda run --no-capture-output -n jupynium pip install .",
    enabled = vim.fn.isdirectory(vim.fn.expand "~/anaconda3/envs/ai"),
    config = function()
      require("jupynium").setup({
        python_host = { "conda", "run", "--no-capture-output", "-n", "ai", "python" },
        default_notebook_URL = "localhost:8888/nbclassic",
      })

      vim.keymap.set("n", "<space>x", ":JupyniumExecuteCell<CR>")
      vim.keymap.set("n", "<space>c", ":JupyniumClearCell<CR>")
      vim.keymap.set("n", "<PageUp>", ":JupyniumScrollNotebookUp<CR>")
      vim.keymap.set("n", "<PageDown>", ":JupyniumScrollNotebookDown<CR>")
      vim.keymap.set("n", "<space>js", ":JupyniumScrollToCell<CR>")
      vim.keymap.set("n", "<space>K", ":JupyniumHover<CR>")
      vim.keymap.set("n", "<space>jo", ":JupyniumToggleOutputScroll<CR>")

    end,
  },
  "rcarriga/nvim-notify",   -- optional
  "stevearc/dressing.nvim", -- optional, UI for :JupyniumKernelSelect
}
