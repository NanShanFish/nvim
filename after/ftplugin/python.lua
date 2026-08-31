local is_dir_exist = require("utils").check_folder_exist

local command = nil

vim.keymap.set({"i", "x", "n"}, "<F5>", function ()
  local filename = vim.fn.expand("%:p")
  if command == nil then
    if is_dir_exist(".venv") then
      command = "Te uv run " .. filename
    else
      command = "Te python " .. filename
    end
  end
  vim.cmd(command)
end, { desc="Python run current file", buffer=true})

vim.api.nvim_create_autocmd("DirChanged", {
  callback = function ()
    command = nil
  end
})
