return {
  "folke/tokyonight.nvim",
  event = "VimEnter",
  config = function()
    vim.cmd([[colorscheme catppuccin]])
    -- vim.cmd([[hi Visual gui=reverse]])
  end
}
