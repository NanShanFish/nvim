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

-- Visual Mode
map("v", "K", "k", opt)

local function find_placeholder(direction)
    if direction == 'w' then
        vim.fn.search("<++>", 'w')
        vim.api.nvim_feedkeys("lva<", "n", false)
    else
        vim.fn.search("<++>", 'b')
        vim.api.nvim_feedkeys("lva<", "n", false)
    end
end
vim.keymap.set({"n","v"}, "<C-n>", function() find_placeholder("w") end, opt)
vim.keymap.set({"n","v"}, "<C-p>", function() find_placeholder("b") end, opt)
