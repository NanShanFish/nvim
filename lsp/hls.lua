---@type vim.lsp.Config
return {
  cmd = { 'haskell-language-server-wrapper', '--lsp' },
  filetypes = { 'haskell', 'lhaskell' },
  root_markers = { ".git", "package.yaml", "hie.yaml", },
  settings = {
    haskell = {
      formattingProvider = 'ormolu',
      cabalFormattingProvider = 'cabalfmt',
    },
  },
}
