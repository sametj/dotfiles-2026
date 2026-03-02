return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      transparent = true,
      commentStyle = { italic = false },
      keywordStyle = { italic = false },
    })
    vim.cmd.colorscheme("kanagawa-wave")
  end,
}

