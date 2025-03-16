return {
    "catppuccin/nvim",
    event = "VimEnter",
    config = function()
        require('catppuccin').setup({
            transparent_background = true,
        })
        vim.cmd([[colorscheme catppuccin-mocha]])
        vim.cmd([[hi Visual gui=reverse]])
    end
}
