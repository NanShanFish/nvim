return {
	"sainnhe/gruvbox-material",
	event = "VimEnter",
	opts = { },
	config = function()
		vim.cmd([[colorscheme gruvbox-material]])
		vim.cmd([[hi Visual gui=reverse]])
	end
}
