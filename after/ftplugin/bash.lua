vim.lsp.enable("bashls")

vim.keymap.set({"i", "x", "n"}, "<F5>", "<cmd>Te bash %:p<cr>" , { desc="Python run current file", buffer=true})
