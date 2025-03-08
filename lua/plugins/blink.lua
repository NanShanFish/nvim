return {
	"saghen/blink.cmp",
	version = not vim.g.lazyvim_blink_main and "*",
	build = vim.g.lazyvim_blink_main and "cargo build --release",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	event = "InsertEnter",

	opts = {
		keymap = { preset = "super-tab", },

		appearance = {
			use_nvim_cmp_as_default = true,
		},
		completion = {
			accept = {
				auto_brackets = { enabled = true, },
			},
			menu = {
				border = 'single',
				draw = {
					treesitter = { "lsp" },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			list = { selection = { preselect = true, auto_insert = true } }
		},

		sources = {
			default = { "lsp", "path", "snippets" },
		},
	},
}
