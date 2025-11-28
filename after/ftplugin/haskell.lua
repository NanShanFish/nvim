vim.lsp.enable("hls")

vim.keymap.set(
  {"i", "x", "n"},
  "<F5>",
  "<cmd>Te runghc %:p<cr>",
  { desc = "Haskell run current file", buffer = true }
)
