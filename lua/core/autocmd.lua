-----------------------------------------------------------
-- Autocmd
-----------------------------------------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      higroup = 'Visual',
      timeout = 1500,
    })
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    vim.diagnostic.config({
      virtual_lines = false,
    })
  end
})
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",

  callback = function()
    if vim.g.virtual_lines_enabled then
      vim.diagnostic.config({
        virtual_lines = { current_line = true},
      })
    end
  end
})


vim.api.nvim_create_autocmd('User', {
  pattern = "VeryLazy",
  callback = function ()
    local function _trigger()
      vim.api.nvim_exec_autocmds("User", { pattern = "NsfLoad" })
    end

    if vim.bo.filetype == "snacks_dashboard" or vim.bo.filetype == "snacks_picker_list" then
      vim.api.nvim_create_autocmd("BufRead", {
        once = true,
        callback = _trigger,
      })
    else
      _trigger()
    end
  end
})
