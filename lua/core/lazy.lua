-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- Plugin: lazy.nvim
-- URL: https://github.com/folke/lazy.nvim
-- Documentation: https://lazy.folke.io/

--[[
For information about installed plugins on neovim-lua see:
neovim-lua/#plugins: https://github.com/brainfucksec/neovim-lua?tab=readme-ov-file#plugins

For details about lazy.nvim configuration, see: https://lazy.folke.io/configuration
--]]

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") ..  "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		-- { "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{ import = "plugins" },
	},
	defaults = {
		lazy = true,
		version = false,
	},
	install = { colorscheme = { "gruvbox" } },
	checker = { enabled = false }, -- automatically check for plugin updates
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"cmp-emoji",
				"matchit",
				"matchparen",
				"netrw",
				"netrwPlugin",
				"netrwSettings",
				"netrwFileHandlers",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
				"spellfile"
			},
		},
	},
})
