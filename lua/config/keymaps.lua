-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------
local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

-- Quick Save
map("n", "<C-s>", "<cmd>w<cr>", opt)

-- Disable mouse drag
map('', "<LeftDrag>", "", opt)
map('', "<LeftRelease>", "", opt)

-- Buffer
map("n", "H", "<cmd>bprev<cr>", opt)
map("n", "L", "<cmd>bn<cr>", opt)
-- map("n", "<leader>bd", "<cmd>bd<cr>", opt)

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h',opt)
map('n', '<C-j>', '<C-w>w',opt)
map('n', '<C-k>', '<C-w>W',opt)
map('n', '<C-l>', '<C-w>l',opt)

-- Term Mode
map("t", "<Esc>", "<C-\\><C-n>", opt)

-- Ctrl + Backspace
map("i","<C-BS>","<C-w>",opt)
map("i","<C-;>","<C-o>:",opt)

vim.keymap.set("n", "K", vim.lsp.buf.hover, opt)
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opt)
-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opt)
vim.keymap.set("n", "grn", vim.lsp.buf.rename, opt)
vim.keymap.set("n", "gri", vim.lsp.buf.implementation, opt)
vim.keymap.set("n", "gra", vim.lsp.buf.code_action, opt)
vim.keymap.set("n", "<M-\\>", vim.diagnostic.open_float, opt)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opt)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opt)
-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------
-- Yazi
-- map("n","<space>e","<cmd>Yazi<cr>",opt)
-- map("n","<space>E","<cmd>Yazi cwd<cr>",opt)

-- Competitest
-- map("n", "\\r", "<cmd>CompetiTest run<cr>", opt)
-- map("n", "\\a", "<cmd>CompetiTest add_testcase<cr>", opt)
-- map("n", "\\c", "<cmd>CompetiTest run_no_compile<cr>", opt)
-- map("n", "\\e", "<cmd>CompetiTest edit_testcase<cr>", opt)
-- map("n", "\\d", "<cmd>CompetiTest delete_testcase<cr>", opt)
-- map("n", "\\<space>", "<cmd>CompetiTest show_ui<cr>", opt)
