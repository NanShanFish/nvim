return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = {
      highlight = { enable = true },
      indent = { enable = true, disable = { "python" } },
      sync_install = false,
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldlevel = 4

      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          -- 'rust',
          'python',
          'c', 'cpp',
          'markdown',
          'bash', 'fish',
          'java',
          'go', 'gomod'
        },
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = "User NsfLoad",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function ()
      require("nvim-treesitter-textobjects").setup()
      local function select_with_fallback(query, group, fallback_keys)
        local start_pos = vim.api.nvim_win_get_cursor(0)
        local mode = vim.api.nvim_get_mode().mode

        -- 尝试使用 Treesitter 块级对象（如 if/for/while 内部）
        local status, _ = pcall(function()
          require("nvim-treesitter-textobjects.select").select_textobject(query, group)
        end)

        local current_pos = vim.api.nvim_win_get_cursor(0)
        local current_mode = vim.api.nvim_get_mode().mode

        -- 如果 Treesitter 没有成功选中（光标未动、模式没变或报错）
        if not status or (start_pos[1] == current_pos[1] and start_pos[2] == current_pos[2] and current_mode == mode) then
          local keys = vim.api.nvim_replace_termcodes(fallback_keys, true, false, true)
          vim.api.nvim_feedkeys(keys, "m", true)
        end
      end
      vim.keymap.set({ "x", "o" }, "af", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "if", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ac", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ic", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "is", function()
        select_with_fallback("@block.inner", "textobjects", "i{")
      end)
      vim.keymap.set({ "x", "o" }, "as", function()
        select_with_fallback("@block.outer", "textobjects", "a{")
      end)
    end
  }
}
