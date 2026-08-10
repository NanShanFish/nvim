return {
  "neovim/nvim-lspconfig",
  event = "User NsfLoad",
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

    vim.lsp.config('ty', {
      cmd = { "ty", "server" },
      filetypes = { "python" },
      root_markers = { ".git", "pyproject.toml", "uv.toml" },
      capabilities = capabilities,
    })

    vim.lsp.enable('pyright', false)
    vim.lsp.enable('basedpyright', false)
    vim.lsp.enable('ty')
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('clangd')

    local icons = require("ui.ui").icons

    local diag_config = {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.Error,
          [vim.diagnostic.severity.WARN] = icons.Warn,
          [vim.diagnostic.severity.HINT] = icons.Hint,
          [vim.diagnostic.severity.INFO] = icons.Info,

        },
      },
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      virtual_lines = { current_line = true },
      virtual_text = false,
      float = {
        focusable = true,
        style = "minimal",

        source = "always",
        header = "docs",
        prefix = "",
        suffix = "",
      },
    }
    vim.diagnostic.config(diag_config)
  end,
}
