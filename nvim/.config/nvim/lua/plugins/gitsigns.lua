return {
  {
    "tpope/vim-fugitive",
    enabled = false,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  }
}
