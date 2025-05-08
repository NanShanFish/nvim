-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------
local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

-- Quick Save
vim.keymap.set({"i", "x", "n", "s"}, "<C-s>", "<cmd>w<cr><esc>l")

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
vim.keymap.set({"n","v"}, "<C-n>", function() find_placeholder("w") end, { desc = "goto next placeholder"})
vim.keymap.set({"n","v"}, "<C-p>", function() find_placeholder("b") end, { desc = "goto prev placeholder"})

-- Diagnostic
local diagnostic_goto = function(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump({
            count= next and 1 or -1,
            severity = severity,
            float = true,
        })
  end
end
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Todo
local function floating_notification(lines)
    if not lines or #lines == 0 then
        print("input is empty")
        return
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local max_width = 0
    for _, line in ipairs(lines) do
        max_width = math.max(max_width, vim.fn.strdisplaywidth(line))
    end
    local width = math.min(max_width + 2, vim.o.columns - 4)  -- 限制最大宽度
    local height = math.min(#lines, vim.o.lines - 4)           -- 限制最大高度

    local win_opts = {
        relative = "editor",
        anchor = "SE",
        width = width,
        height = height,
        row = vim.o.lines - 1,
        col = vim.o.columns - 1,
        style = "minimal",
        border = "rounded",
        title = "Todo List",
        title_pos = "center",
        focusable = false,
    }

    local win = vim.api.nvim_open_win(buf, false, win_opts)

    vim.defer_fn(function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end, 30000)
end
vim.keymap.set("n", "<leader>ft", function() local todo=vim.fn.systemlist("bash ~/scr/todo.sh"); floating_notification(todo) end, {desc = "Query todo"})
vim.keymap.set("n", "<leader>fT", function() vim.cmd("rightbelow vsplit " .. "~/doc/notes/2-daily/Todo/todo.md"); vim.api.nvim_win_set_width(0, 80); end, {desc = "Open todo file"})
