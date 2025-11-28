local M = {}

vim.cmd([[
  highlight UserText guifg=#cad3f5
  highlight UserRed guifg=#ed8796
  highlight UserPeach guifg=#ef9f76
  highlight UserYellow guifg=#eed49f
  highlight UserGreen guifg=#a6da95
  highlight UserCyan guifg=#8bd5ca
  highlight UserBlue guifg=#8aadf4
  highlight UserPurple guifg=#c6a0f6
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
