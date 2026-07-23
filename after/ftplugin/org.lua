vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.wo.colorcolumn=""
vim.wo.wrap = true
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true, buffer=0})
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true, buffer=0})
