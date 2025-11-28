vim.lsp.enable("clangd")

vim.keymap.set(
  {"i", "x", "n"},
  "<F5>",
  "<cmd>Te gcc %:p -o /tmp/%:t:r.out && /tmp/%:t:r.out<cr>",
  { desc = "Cpp run current file", buffer = true }
)
