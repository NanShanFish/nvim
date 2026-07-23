return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "User NsfLoad",
    opts = {
      highlight = { enable = true },
      indent = { enable = true, disable = { "python" } },
      ensure_installed = {
        "awk",
        "regex",

        "c",
        "cpp",
        "make",

        "bash",
        "fish",

        "python",
        "lua",
        "luadoc",

        "markdown",
        "markdown_inline",

        "toml",
        "yaml",
        "json",

        "vim",
        "vimdoc",
      },
      sync_install = false,
    },
    config = function(_, opts)
      local status_ok, ts = pcall(require, "nvim-treesitter")
      if status_ok and ts.setup then
        ts.setup(opts)
      else
        require("nvim-treesitter.configs").setup(opts)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("my_treesitter_attach", { clear = true }),
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
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
        require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
      end)
    end
  }
}
