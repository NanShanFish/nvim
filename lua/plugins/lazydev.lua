return {
  "folke/lazydev.nvim",
  ft = "lua",
  config = function()
    require("lazydev").setup({
      library = { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "luals" then

          local current_file = vim.api.nvim_buf_get_name(args.buf)

          -- 只有路径里包含 'nvim' 或 'lazy'，才去激活 Neovim 插件环境
          if current_file:match("nvim") or current_file:match("lazy") then

            require("lazydev.lsp").attach(client)
          end

        end
      end,
    })
  end
}
