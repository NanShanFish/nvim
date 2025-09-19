return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = "User NsfLoad",
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
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
			textobjects = {
				select = {
					enable = true,
					keymap = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
					}
				}
			}
		},
		config = function (_, opts)
			require'nvim-treesitter.configs'.setup(opts)
		end
	},
	{
		'nvim-treesitter/nvim-treesitter-textobjects',
		event = "User NsfLoad",
		dependencies = { "nvim-treesitter/nvim-treesitter" }
	}
}
