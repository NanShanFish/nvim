return {
  'saghen/blink.cmp',
  event = "InsertEnter",
  dependencies = {
    'saghen/blink.lib',
    -- optional: provides snippets for the snippet source
    'rafamadriz/friendly-snippets',
  },
  build = function()
    require('blink.cmp').build():pwait()
  end,

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
        org = { 'orgmode', 'lsp', 'path', 'snippets' },
        markdown = { 'lsp', 'path', 'snippets' },
        lua = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer'}
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
-- return {
--   "saghen/blink.cmp",
--   dependencies = {
--     "rafamadriz/friendly-snippets",
--   },
--   event = "InsertEnter",
--   version = "*",
--   opts = {
--     signature = {
--       enabled = true,
--       window = { border = "single" }
--     },
--     cmdline = {
--       keymap = {
--         -- 选择并接受预选择的第一个
--         ["<Tab>"] = { "select_next", "fallback" },
--         ["<S-Tab>"] = { "select_next", "fallback" },
--         ["<Left>"] = { "fallback" },
--         ["<Right>"] = { "fallback" },
--       },
--       completion = {
--         -- 不预选第一个项目，选中后自动插入该项目文本
--         list = { selection = { preselect = false, auto_insert = true } },
--         -- 自动显示补全窗口，仅在输入命令时显示菜单，而搜索或使用其他输入菜单时则不显示
--         menu = {
--           ---@diagnostic disable-next-line: unused-local
--           auto_show = function(_ctx)
--             return vim.fn.getcmdtype() == ":"
--           end,
--         },
--         -- 不在当前行上显示所选项目的预览
--         ghost_text = { enabled = false },
--       },
--     },
--     keymap = {
--       preset = "none",
--       ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
--       ["<CR>"] = {  "accept", "fallback" },
--       ["<C-p>"] = { "select_prev", "snippet_backward", "fallback" },
--       ["<C-n>"] = { "select_next", "snippet_forward", "fallback" }, -- 同时存在补全列表和snippet时，补全列表选择优先级更高
--
--       ["<C-b>"] = { "scroll_documentation_up", "fallback" },
--       ["<C-f>"] = { "scroll_documentation_down", "fallback" },
--     },
--     completion = {
--       -- 示例：使用'prefix'对于'foo_|_bar'单词将匹配'foo_'(光标前面的部分),使用'full'将匹配'foo__bar'(整个单词)
--       keyword = { range = "full" },
--       documentation = { auto_show = true, auto_show_delay_ms = 200 },
--       list = { selection = { preselect = false, auto_insert = true } },
--     },
--
--     appearance = {
--       use_nvim_cmp_as_default = true,
--       nerd_font_variant = "mono",
--     },
--
--     sources = {
--       -- 针对特定文件类型定制启用的补全源
--       per_filetype = {
--         org = { 'orgmode', 'lsp', 'path', 'snippets' },
--         markdown = { 'lsp', 'path', 'snippets' },
--         lua = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer'}
--       },
--
--       default = {
--         "lsp",
--         "snippets",
--         "path",
--         "buffer",
--       },
--
--       providers = {
--         buffer = { score_offset = 1 },
--         path = { score_offset = 3 },
--         lsp = { score_offset = 5 },
--         snippets = { score_offset = 4 },
--         orgmode = {
--           name = "Orgmode",
--           module = 'orgmode.org.autocompletion.blink',
--           score_offset = 4,
--         },
--         lazydev = {
--           name = "LazyDev",
--           module = "lazydev.integrations.blink",
--           score_offset = 100,
--         },
--       },
--     },
--   },
--   opts_extend = { "sources.default" },
-- }
--
