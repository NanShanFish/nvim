return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	-- event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	opts = {
		window = {
			position = "float",
			-- position = "left",
			mappings = {
				["p"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
				["P"] = { "paste_from_clipboard" },
				["<Tab>"] = { "toggle_node" },
				["l"] = "open",
				["-"] = "navigate_up",
			},
		},
	},
	keys = {
		{ "<leader>e", "<cmd>Neotree float<cr>" },
		{ "<leader>E", "<cmd>Neotree toggle left<cr>" },
	}
}
