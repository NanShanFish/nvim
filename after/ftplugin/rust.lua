vim.lsp.enable('rust_analyzer')

local check_file_exist = require('utils').check_file_exist
local first_run = require("utils").once_per_filetype

vim.keymap.set({"i", "x", "n"},
  "<F5>",
  "<cmd>Te rustc %:p -o /tmp/%:t:r.out && /tmp/%:t:r.out<cr>",
  { desc="Rust run current file", buffer = true }
)

first_run("rust", function ()
  if check_file_exist("Cargo.toml") then
    vim.keymap.set({"i", "x", "n"}, "<F6>", "<cmd>Te cargo run<cr>", { desc="Cargo run" } )
    vim.keymap.set({"i", "x", "n"}, "<F7>", "<cmd>Te cargo test<cr>", { desc="Cargo run test" } )
  end
end)

