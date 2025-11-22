local M = {}

vim.cmd([[
  highlight UserText guifg=#cad3f5
  highlight UserRed gui=bold guifg=#ed8796
  highlight UserPeach gui=bold guifg=#ef9f76
  highlight UserYellow gui=bold guifg=#eed49f
  highlight UserGreen gui=bold guifg=#a6da95
  highlight UserCyan gui=bold guifg=#8bd5ca
  highlight UserBlue gui=bold guifg=#8aadf4
  highlight UserPurple gui=bold guifg=#c6a0f6
  highlight UserPink gui=bold guifg=#f5bde6
]])

M.icons = {
  Class = " ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = "󰊕 ",
  Interface = " ",

  Keyword = " ",
  Method = "ƒ ",
  Module = "󰏗 ",
  Property = " ",
  Snippet = " ",
  Struct = " ",

  Text = " ",
  Unit = " ",

  Value = " ",
  Variable = " ",
  Error = "✘",
  Warn = "▲",
  Hint = "!",
  Info = "»",
}

return M
