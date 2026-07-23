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

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Move around splits using Ctrl + {h,j,k,l}
map({"n", "t"}, '<C-h>', '<C-\\><C-n><C-w>h',opt)
map({"n", "t"}, '<C-j>', '<C-\\><C-n><C-w>w',opt)
map({"n", "t"}, '<C-k>', '<C-\\><C-n><C-w>W',opt)
map({"n", "t"}, '<C-l>', '<C-\\><C-n><C-w>l',opt)

local te_ns = vim.api.nvim_create_namespace("te_prompt")
local function run_async_cmd(bufnr, winid, cmd)
  local existing_job = vim.b[bufnr].te_job_id
  if existing_job then
    vim.fn.jobstop(existing_job)
  end

  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
    cmd,
    string.rep("-", 40),
    ""
  })

  local existing_marks = vim.api.nvim_buf_get_extmarks(bufnr, te_ns, 0, -1, { limit = 1 })
  if #existing_marks == 0 then
    vim.api.nvim_buf_set_extmark(bufnr, te_ns, 0, 0, {
      virt_text = { { "$ ", "Function" } },
      virt_text_pos = "inline",
      right_gravity = false,
    })
  end

  local function on_output(_, data, _)
    if not data or (#data == 1 and data[1] == "") then return end

    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then return end
      vim.bo[bufnr].modifiable = true

      local line_count = vim.api.nvim_buf_line_count(bufnr)
      local last_line = vim.api.nvim_buf_get_lines(bufnr, line_count - 1, line_count, false)[1]

      data[1] = last_line .. data[1]

      vim.api.nvim_buf_set_lines(bufnr, line_count - 1, line_count, false, data)
    end)
  end

  local job_id = vim.fn.jobstart(cmd, {
    on_stdout = on_output,
    on_stderr = on_output,
    on_exit = function(_, code, _)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then return end
        vim.bo[bufnr].modifiable = true
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {
          string.rep("-", 40),
          "Process exited with code: " .. code
        })
        vim.b[bufnr].te_job_id = nil -- 清除任务标记
      end)
    end
  })

  if job_id > 0 then
    vim.fn.chanclose(job_id, "stdin")
  end

  vim.b[bufnr].te_job_id = job_id
end

local function setup_term_mappings(bufnr, winid, cmd, source_win)
  -- 提取一个通用的关闭函数，供 q 和 <CR> 共同使用
  local function close_te_buffer()
    local job_id = vim.b[bufnr].te_job_id
    if job_id then 
      pcall(vim.fn.jobstop, job_id) 
    end
    pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
  end

  -- 1. 映射 <F6>：重新运行命令
  vim.keymap.set("n", "<F6>", function()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
    local current_cmd = cmd 

    if lines and #lines > 0 and lines[1] ~= "" then
      current_cmd = lines[1] 
    end

    run_async_cmd(bufnr, winid, current_cmd)
    vim.notify("Re-ran: " .. current_cmd, vim.log.levels.INFO)
  end, { buffer = bufnr, noremap = true, silent = true, desc = "Re-run edited command" })

  -- 2. 映射 q：调用通用关闭函数
  vim.keymap.set("n", "q", close_te_buffer, { buffer = bufnr, noremap = true, silent = true, desc = "Close Te buffer" })

  -- 3. 映射 <CR>：解析路径并跳转，或者退出
  vim.keymap.set("n", "<CR>", function()
    local cfile = vim.fn.expand('<cfile>')
    local cWORD = vim.fn.expand('<cWORD>')

    -- 👉 修改点：如果光标下没有文件路径，直接执行退出功能
    if not cfile or cfile == "" then
      close_te_buffer()
      return
    end

    local safe_cfile = cfile:gsub("[%-%^%$%(%)%%%.%[%]%*%+%?]", "%%%0")
    local line, col = string.match(cWORD, safe_cfile .. ":(%d+):(%d+)")
    if not line then
      line = string.match(cWORD, safe_cfile .. ":(%d+)")
    end

    -- 👉 修改点：如果文件不存在（比如光标刚好在普通的单词上），也执行退出功能
    if vim.fn.filereadable(cfile) == 0 then
      close_te_buffer()
      return
    end

    local target_jump_win = nil

    if source_win and vim.api.nvim_win_is_valid(source_win) then
      local ok, is_te = pcall(vim.api.nvim_win_get_var, source_win, "is_te_window")
      if not (ok and is_te) then
        target_jump_win = source_win
      end
    end

    if not target_jump_win then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local ok, is_te = pcall(vim.api.nvim_win_get_var, win, "is_te_window")
        if not (ok and is_te) then
          target_jump_win = win
          break
        end
      end
    end

    if target_jump_win then
      vim.api.nvim_set_current_win(target_jump_win)
    else
      vim.cmd("aboveleft split")
    end

    vim.cmd("edit " .. vim.fn.fnameescape(cfile))

    if line then
      local lnum = tonumber(line)
      local cnum = tonumber(col) or 1
      pcall(vim.api.nvim_win_set_cursor, 0, {lnum, math.max(0, cnum - 1)})
      vim.cmd("normal! zz")
    end
  end, { buffer = bufnr, noremap = true, silent = true, desc = "Go to file safely or close" })
end

vim.api.nvim_create_user_command("Te", function(opts)
  local cmd = opts.args
  if cmd == "" then return end

  local source_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_get_current_buf()

  local modifiable = vim.bo[current_buf].modifiable
  local readonly = vim.bo[current_buf].readonly
  if modifiable and not readonly then
    vim.cmd("silent! w")
  end

  local target_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ok, is_te = pcall(vim.api.nvim_win_get_var, win, "is_te_window")
    if ok and is_te then
      target_win = win
      break
    end
  end

  local target_buf = nil

  if target_win and vim.api.nvim_win_is_valid(target_win) then
    vim.api.nvim_set_current_win(target_win)
    target_buf = vim.api.nvim_win_get_buf(target_win)
  else
    vim.cmd("botright 10split")
    target_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_var(target_win, "is_te_window", true)

    target_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(target_win, target_buf)
  end

  vim.wo[target_win].wrap = true
  if vim.fn.has('nvim-0.10') == 1 then
    vim.wo[target_win].winfixbuf = true
  end

  vim.bo[target_buf].buftype = "nofile"
  vim.bo[target_buf].bufhidden = "hide"
  vim.bo[target_buf].swapfile = false
  vim.bo[target_buf].modifiable = true
  vim.bo[target_buf].buflisted = false

  setup_term_mappings(target_buf, target_win, cmd, source_win)

  run_async_cmd(target_buf, target_win, cmd)

end, { nargs = "+" })

map( {"n", "i", "x"}, '<F6>', "<cmd>Te make<cr>", opt)
map( {"n", "i", "x"}, '<F7>', "<cmd>Te make %:t:r<cr>", opt)
map( {"n", "x"}, '\\\\', ":Te ", opt)

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

-- CmdLine
map("c", "<C-a>", "<Home>", opt)

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

vim.g.errorline_state = 1
local function toggle_errorline_status()
  if vim.g.errorline_state == 1 then
    vim.diagnostic.config{ signs = false, virtual_lines = false, virtual_text = false }
    vim.g.errorline_state = 2
	elseif vim.g.errorline_state == 2 then
    vim.diagnostic.config{ signs = true, virtual_lines = false, virtual_text = true }
    vim.g.errorline_state = 3
  else
    vim.diagnostic.config{ virtual_lines = { current_line = true }, virtual_text = false }
    vim.g.errorline_state = 1
  end
end
map("n", "<leader>ue", toggle_errorline_status, { desc = "toggle error line"})


-- ig => Entire Buffer text-object
map({"o", "x"}, "ig", ":<C-u>normal! ggVG<cr>", { desc = "Entire Buffer" })


local diff_buf_id = -1
vim.keymap.set("n", "<leader>gd", function()
    if vim.api.nvim_buf_is_valid(diff_buf_id) and vim.api.nvim_buf_is_loaded(diff_buf_id) then
        vim.cmd('diffoff!')
        vim.api.nvim_buf_delete(diff_buf_id, { force = true })
        diff_buf_id = -1 -- 重置 ID
        return
    end

    local file_path = vim.fn.expand('%:p:.')
    local filetype = vim.bo.filetype

    if file_path == "" then
        print("当前 Buffer 没有文件路径")
        return
    end

    local git_cmd = "git show HEAD:" .. file_path
    local content = vim.fn.systemlist(git_cmd)

    if vim.v.shell_error ~= 0 then
        print("Git 错误: 无法获取 HEAD 版本内容")
        return
    end

    vim.cmd('vnew')
    diff_buf_id = vim.api.nvim_get_current_buf()

    vim.api.nvim_buf_set_lines(diff_buf_id, 0, -1, false, content)
    vim.bo[diff_buf_id].buftype = 'nofile'
    vim.bo[diff_buf_id].bufhidden = 'wipe'
    vim.bo[diff_buf_id].swapfile = false
    vim.bo[diff_buf_id].filetype = filetype
    vim.api.nvim_buf_set_name(diff_buf_id, "Git-Revision: " .. file_path)

    vim.cmd('diffthis')
    vim.cmd('wincmd p')
    vim.cmd('diffthis')
    vim.cmd('wincmd p')

    -- 添加析构 call back
    vim.api.nvim_buf_attach(diff_buf_id, false, {
        on_detach = function()
            diff_buf_id = -1
            pcall(function() vim.cmd('diffoff!') end)
        end
    })

end, { desc = "Toggle Git Diff" })


local default_dairy_format = "~/org/journal/%Y/%m/%Y-%m-%d.org"
local todo_file = "~/org/gtd.org"
local function open_diary(date_str)
  local filename = nil
  if string.lower(date_str) == 'todo' then
    filename = todo_file
  else
    local dairy_format = default_dairy_format

    local cmd = 'date -d ' .. vim.fn.shellescape(date_str) .. ' "+' .. dairy_format .. '"'
    filename = vim.fn.system(cmd)

    if vim.v.shell_error ~= 0 then
      vim.notify("Date parse error: " .. vim.trim(filename), vim.log.levels.ERROR)
      return
    end
    filename = vim.trim(filename)
  end
  local full_path = vim.fn.expand(filename)

  local parent_dir = vim.fn.fnamemodify(full_path, ":h")
  if vim.fn.isdirectory(parent_dir) == 0 then
    local success = vim.fn.mkdir(parent_dir, "p")
    if success == 0 then
      vim.notify("Failed to create directory: " .. parent_dir, vim.log.levels.ERROR)
      return
    end
    vim.notify("Created directory: " .. parent_dir, vim.log.levels.INFO)
  end

  vim.cmd("edit " .. vim.fn.fnameescape(full_path))
end

local function diary_command(opts)
  local input = opts.args
  if input == "" then
    input = vim.fn.input("Enter date string: ")
    if input == "" then
      vim.notify("Empty input, abort.", vim.log.levels.WARN)
      return
    end
  end
  open_diary(input)
end

vim.api.nvim_create_user_command("OD", diary_command, {
  nargs = "?",
  desc = "Open diary file for a given date (e.g. :OD tomorrow, :OD 2026-06-22)"
})

-- 可选按键映射
-- vim.keymap.set("n", "<leader>od", function() diary_command({ args = "" }) end, { desc = "Open diary by date input" })
