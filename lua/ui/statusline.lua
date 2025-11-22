local icons = require("ui.ui").icons

vim.opt.showmode = false

local function get_mode()
  local mode = vim.api.nvim_get_mode().mode
  local mode_map = {
    n = "N",
    i = "I",
    v = "V",
    V = "V-L",
    ["\22"] = "V-B",
    c = "C",
    t = "T",
    niI = "I-N"
  }

  return mode_map[mode] or mode:upper()
end

vim.g.tpipeline_cursormoved = 0
local recording_register = ""

local function get_lsp_errors()
  if not vim.diagnostic then
    return ""
  end
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }) +
  #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  local result = ""
  if errors > 0 then
    result = result .. " %#UserRed#" .. icons.Error .. errors
  end
  if warnings > 0 then
    result = result .. " %#UserYellow#".. icons.Warn .. warnings
  end
  if hints > 0 then
    result = result .. " %#UserCyan#" .. icons.Hint .. hints
  end
  return result
end

local function get_buffer_list()
  local buffers = {}
  local current_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      local name = vim.api.nvim_buf_get_name(buf)
      if name == "" then
        name = "No Name"
      else
        name = vim.fn.fnamemodify(name, ":t")
      end
      if vim.bo[buf].modified then
        name = name .. " +"
      end

      if buf == current_buf then
        name = "%#UserText#[" .. name .. "]%*"
      end
      table.insert(buffers, name)
    end
  end
  return table.concat(buffers, "|")
end

local function get_recording()
  recording_register = vim.fn.reg_recording()
  if recording_register ~= "" then
    recording_register = "@" .. recording_register
  end
  return recording_register
end

function _G.custom_statusline()
  local mode = get_mode()
  local buffer_list = get_buffer_list()
  local lsp_errors = get_lsp_errors()

  local statusline_str = "%#UserPink# " .. mode .. " %*"
  statusline_str = statusline_str .. buffer_list
  if lsp_errors ~= "" then
    statusline_str = statusline_str .. lsp_errors .. "%* "
  end

  statusline_str = statusline_str .. "%= "

  -- Right
  statusline_str = statusline_str
  .. get_recording() .. " "
  .. "[" .. vim.bo.fileformat .. "-" .. vim.bo.fileencoding .. "] "

  return statusline_str
end


vim.opt.statusline = "%!v:lua.custom_statusline()"
