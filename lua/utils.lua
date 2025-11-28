local M = {}
M.check_folder_exist = function (dir_name)
  local cwd = vim.fn.getcwd()
  local full_path = cwd .. "/" .. dir_name
  return vim.fn.isdirectory(full_path) ~= 0
end

M.check_file_exist = function (file_name)
  local cwd = vim.fn.getcwd()
  local full_path = cwd .. "/" .. file_name
  return vim.fn.filereadable(full_path) ~= 0
end

local initialized_filetypes = {}

M.once_per_filetype = function(filetype, callback)
    if not initialized_filetypes[filetype] then
        callback()
        initialized_filetypes[filetype] = true
    end
end

return M
