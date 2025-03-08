---@type LazySpec
return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	---@type YaziConfig
	opts = {
		open_for_directories = true,
		keymaps = {
			show_help = '<f1>',
		},
	},
}
