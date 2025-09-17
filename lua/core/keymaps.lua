-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------
local map = vim.keymap.set
local opt = { noremap = true, silent = true }

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

-- Quick Save
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Disable mouse drag
map('', "<LeftDrag>", "", opt)
map('', "<LeftRelease>", "", opt)

-- Buffer
map("n", "H", "<cmd>bprev<cr>", opt)
map("n", "L", "<cmd>bn<cr>", opt)

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h',opt)
map('n', '<C-j>', '<C-w>w',opt)
map('n', '<C-k>', '<C-w>W',opt)
map('n', '<C-l>', '<C-w>l',opt)

-- Esc
map({ "i", "n", "s" }, "<esc>", function()
    vim.cmd("noh")
    return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Term Mode
map("t", "<Esc>", "<C-\\><C-n>", opt)

-- Ctrl + Backspace
map("i","<C-BS>","<C-w>",opt)
map("i","<C-;>","<C-o>:",opt)

-- Visual Mode
map("v", "K", "k", opt)

map("n", "<leader>cs", "<cmd>LspRestart<cr>", opt)

-- Placeholder
local function find_placeholder(direction)
    vim.api.nvim_feedkeys("", "n", false)
    if direction == 'w' then
        vim.fn.search("<++>", 'w')
        vim.api.nvim_feedkeys("lva<", "n", false)
    else
        vim.fn.search("<++>", 'b')
        vim.api.nvim_feedkeys("lva<o", "n", false)
    end
end
map({"n","v"}, "<C-n>", function() find_placeholder("w") end, { desc = "goto next placeholder"})
map({"n","v"}, "<C-p>", function() find_placeholder("b") end, { desc = "goto prev placeholder"})

map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Diagnostic
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>uS")

if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>uh")
end


-- -- Todo
-- local function floating_notification(lines)
--     if not lines or #lines == 0 then
--         print("input is empty")
--         return
--     end
--
--     local buf = vim.api.nvim_create_buf(false, true)
--     vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
--
--     local max_width = 0
--     for _, line in ipairs(lines) do
--         max_width = math.max(max_width, vim.fn.strdisplaywidth(line))
--     end
--     local width = math.min(max_width + 2, vim.o.columns - 4)  -- 限制最大宽度
--     local height = math.min(#lines, vim.o.lines - 4)           -- 限制最大高度
--
--     local win_opts = {
--         relative = "editor",
--         anchor = "SE",
--         width = width,
--         height = height,
--         row = vim.o.lines - 1,
--         col = vim.o.columns - 1,
--         style = "minimal",
--         border = "rounded",
--         title = "Todo List",
--         title_pos = "center",
--         focusable = false,
--     }
--
--     local win = vim.api.nvim_open_win(buf, false, win_opts)
--
--     vim.defer_fn(function()
--         if vim.api.nvim_win_is_valid(win) then
--             vim.api.nvim_win_close(win, true)
--         end
--         if vim.api.nvim_buf_is_valid(buf) then
--             vim.api.nvim_buf_delete(buf, { force = true })
--         end
--     end, 30000)
-- end
-- vim.keymap.set("n", "<leader>ft", function() local todo=vim.fn.systemlist("bash ~/scr/todo.sh"); floating_notification(todo) end, {desc = "Query todo"})
-- vim.keymap.set("n", "<leader>fT", function() vim.cmd("rightbelow vsplit " .. "~/doc/notes/2-daily/Todo/todo.md"); vim.api.nvim_win_set_width(0, 80); end, {desc = "Open todo file"})
