return {
	{
		'echasnovski/mini.ai',
		version = false,
		event = "VeryLazy",
		opts = {},
	},
	{
		'echasnovski/mini.tabline',
		version = false,
		event = {
			"BufAdd",
		},
		opts = {
			show_icons = false
		}
	},
	{
		'echasnovski/mini.pairs',
		version = false,
		event = "InsertEnter",
		opts = {},
	},
	-- {
	-- 	'echasnovski/mini.indentscope',
	-- 	version = false,
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		animation = function(s, n)
	-- 			return 50
	-- 		end,
	-- 		symbol = '|',
	-- 	}
	-- },
}
