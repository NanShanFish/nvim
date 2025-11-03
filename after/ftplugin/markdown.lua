vim.wo.colorcolumn=""
vim.wo.wrap = true
vim.keymap.set("x", "<localleader>b", "\"1c**<C-R>1**<ESC>", { silent = true, buffer = 0 })
vim.keymap.set("x", "<localleader>i", "\"1c*<C-R>1*<ESC>", { silent = true, buffer = 0 })
vim.keymap.set("x", "<localleader>u", '\"1c<u><C-R>1</u><ESC>', { silent = true, buffer = 0 })
vim.keymap.set("x", "<localleader>s", '\"1c<s><C-R>1</s><ESC>', { silent = true, buffer = 0 })
vim.keymap.set("x", "<localleader>c", '\"1c`<C-R>1`<ESC>', { silent = true, buffer = 0 })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true, buffer=0})
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true, buffer=0})
-- vim.keymap.set("i", ",", ",u", { expr = true, silent = true, buffer = 0})
-- vim.keymap.set("i", ".", ".u", { expr = true, silent = true, buffer = 0})
-- vim.keymap.set("i", ";", ";u", { expr = true, silent = true, buffer = 0})
