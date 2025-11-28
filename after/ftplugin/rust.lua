vim.lsp.enable('rust_analyzer')

vim.keymap.set({"i", "x", "n"},
  "<F5>",
  "<cmd>Te rustc %:p -o /tmp/%:t:r.out && /tmp/%t:r.out<cr>",
  { desc="Rust run current file", buffer = true }
)

local first_run = require("utils").once_per_filetype
first_run("rust", function ()
  vim.keymap.set({"i", "x", "n"}, "<F6>", "<cmd>Te cargo run<cr>", { desc="Cargo run" } )
  vim.keymap.set({"i", "x", "n"}, "<F7>", "<cmd>Te cargo test<cr>", { desc="Cargo run test" } )
end)
