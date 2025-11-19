return {
  "folke/tokyonight.nvim",
  event = "VimEnter",
  config = function()
    vim.cmd([[colorscheme tokyonight]])
    vim.cmd([[hi Visual gui=reverse]])
  end
}
