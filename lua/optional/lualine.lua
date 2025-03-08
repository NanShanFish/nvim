return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			-- set an empty statusline till lualine loads
			vim.o.statusline = " "
		else
			-- hide the statusline on the starter page
			vim.o.laststatus = 0
		end
	end,
	opts = function()
		local lualine_require = require("lualine_require")
		lualine_require.require = require

		LazyVim = require("lazy-nvim")
		local icons = LazyVim.config.icons

		vim.o.laststatus = vim.g.lualine_laststatus

		local opts = {
			options = {
				theme = "palenight",
				globalstatus = vim.o.laststatus == 3,
				disabled_filetypes = { statusline = { "alpha" } },
				component_separators = '',
				section_separators = '',
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch"
				},
				lualine_c = {
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
					},
				},

				lualine_x = {
					{
						'filename',
						file_status = false,
						path = 4
					}
				},
				lualine_y = {
					{'encoding'},
					{'fileformat'}
				},
				lualine_z = {
					{
						'buffers',
						show_filename_only = true,
						hide_filename_extension = true,
						show_modified_status = false,
					}
				},
			},
		}
		return opts
	end,
}
