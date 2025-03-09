return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = { },
	keys = {
		-- {
		-- 	"<leader>?",
		-- 	function()
		-- 		require("which-key").show({ global = false })
		-- 	end,
		-- 	desc = "Buffer Local Keymaps (which-key)",
		-- },
	},
	config = function ()
		local wk = require("which-key")
		wk.add({
			{ "gr", group = "Lsp action" },
			{ "grn", vim.lsp.buf.rename, desc = "Rename" },
			{ "gri", vim.lsp.buf.implementation, desc = "Implementation" },
			{ "gra", vim.lsp.buf.code_action, desc = "Code action" },
			{ "[d", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },
			{ "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
		})
	end
}
