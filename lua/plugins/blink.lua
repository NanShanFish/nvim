return {
  'saghen/blink.cmp',
  event = { "InsertEnter", "CmdlineEnter" },
  version = "*",
  build = 'cargo build --release',
  dependencies = {
    'saghen/blink.lib',
    'rafamadriz/friendly-snippets',
  },


  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    cmdline = {
      keymap = {
        -- 选择并接受预选择的第一个
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_next", "fallback" },
        ["<Left>"] = { "fallback" },
        ["<Right>"] = { "fallback" },
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = true } },
        menu = {
          ---@diagnostic disable-next-line: unused-local
          auto_show = function(ctx)
            return vim.fn.getcmdtype() == ":"
          end,
        },
        ghost_text = { enabled = false },
      },
    },
    completion = {
      keyword = { range = "full" },
      documentation = { auto_show = true, auto_show_delay_ms = 1000 },
      list = { selection = { preselect = false, auto_insert = true } },
      menu = { draw = { columns = { { "label", "label_description", gap = 1 }, { "kind" } }}}
    },
    signature = { enabled = true, },
    keymap = {
      preset = "none",
      ["<C-e>"] = { "show", "show_documentation", "hide_documentation" },
      ["<CR>"] = {  "accept", "fallback" },
      ["<C-p>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-n>"] = { "select_next", "snippet_forward", "fallback" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },



    sources = {
      per_filetype = {
        org = { 'orgmode', 'path', 'snippets' },
        markdown = { 'lsp', 'path', 'snippets' },
        -- lua = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer'}
      },

      default = {
        "lsp",
        "snippets",
        "path",
        "buffer",
      },

      providers = {
        buffer = { score_offset = 1 },
        path = { score_offset = 3 },
        lsp = { score_offset = 5 },
        snippets = { score_offset = 4 },
        orgmode = {
          name = "Orgmode",
          module = 'orgmode.org.autocompletion.blink',
          score_offset = 4,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },

  -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
  -- You may use a lua implementation instead by using `implementation = "lua"`
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "rust" }
  },
}
