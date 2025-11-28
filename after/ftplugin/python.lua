vim.lsp.enable('basedpyright')
local is_dir_exist = require("utils").check_folder_exist

local command = nil

vim.keymap.set({"i", "x", "n"}, "<F5>", function ()
  if command == nil then
    if is_dir_exist(".venv") then
      command = "<cmd>Te uv run %:p<cr>"
    else
      command = "<cmd>Te python %:p<cr>"
    end
  else
    vim.cmd(command)
  end
end, { desc="Python run current file", buffer=true})

vim.api.nvim_create_autocmd("DirChanged", {
  callback = function ()
    command = nil
  end
})
