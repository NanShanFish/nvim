return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	enabled = true,
	init = false,
	opts = function()
-- ███████╗██╗███████╗██╗  ██╗
-- ██╔════╝██║██╔════╝██║  ██║
-- █████╗  ██║███████╗███████║
-- ██╔══╝  ██║╚════██║██╔══██║
-- ██║     ██║███████║██║  ██║
-- ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝

		local dashboard = require("alpha.themes.dashboard")
		-- Define and set highlight groups for each logo line
		vim.api.nvim_set_hl(0, "NeovimDashboardLogo1", { fg = "#d44b3a" }) -- Indigo
		vim.api.nvim_set_hl(0, "NeovimDashboardLogo2", { fg = "#fb865c" }) -- Deep Purple
		vim.api.nvim_set_hl(0, "NeovimDashboardLogo3", { fg = "#fdc76f" }) -- Deep Purple
		vim.api.nvim_set_hl(0, "NeovimDashboardLogo4", { fg = "#07fb0f" }) -- Medium Purple
		vim.api.nvim_set_hl(0, "NeovimDashboardLogo5", { fg = "#03acff" }) -- Light Purple
		vim.api.nvim_set_hl(0, "NeovimDashboardLogo6", { fg = "#582589" }) -- Very Light Purple
		vim.api.nvim_set_hl(0, "NeovimDashboardUsername", { fg = "#D1C4E9" }) -- Light purple
		dashboard.section.header.type = "group"
		dashboard.section.header.val = {
			{
				type = "text",
				val = "███████╗██╗███████╗██╗  ██╗",
				opts = { hl = "NeovimDashboardLogo1", shrink_margin = false, position = "center" },
			},
			{
				type = "text",
				val = "██╔════╝██║██╔════╝██║  ██║",
				opts = { hl = "NeovimDashboardLogo2", shrink_margin = false, position = "center" },
			},
			{
				type = "text",
				val = "█████╗  ██║███████╗███████║",
				opts = { hl = "NeovimDashboardLogo3", shrink_margin = false, position = "center" },
			},
			{
				type = "text",
				val = "██╔══╝  ██║╚════██║██╔══██║",
				opts = { hl = "NeovimDashboardLogo4", shrink_margin = false, position = "center" },
			},
			{
				type = "text",
				val = "██║     ██║███████║██║  ██║",
				opts = { hl = "NeovimDashboardLogo5", shrink_margin = false, position = "center" },
			},
			{
				type = "text",
				val = "╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝",
				opts = { hl = "NeovimDashboardLogo6", shrink_margin = false, position = "center" },
			},
			{
				type = "padding",
				val = 1,
			},
			-- {
			--   type = "text",
			--   val = "𝙾𝚑 𝚝𝚑𝚎 𝚓𝚘𝚢 𝚘𝚏 𝚑𝚊𝚟𝚒𝚗𝚐 𝚢𝚘𝚞𝚛 𝚘𝚠𝚗 𝚌𝚞𝚜𝚝𝚘𝚖 𝚝𝚎𝚡𝚝 𝚎𝚍𝚒𝚝𝚘𝚛 :)",
			--   opts = { hl = "NeovimDashboardUsername", shrink_margin = false, position = "center" },
			-- },
		}
		-- stylua: ignore
		dashboard.section.buttons.val = {
			-- dashboard.button("f", " " .. " Find file",       LazyVim.pick()),
			-- dashboard.button("f", " " .. " Find file",       LazyVim.pick.wrap("files", { cwd = "~/proj" })),
			-- dashboard.button("n", " " .. " Notes",           LazyVim.pick.wrap("files", { cwd = "$XDG_DOCUMENTS_DIR/daily/" })),
			-- dashboard.button("r", " " .. " Recent files",    LazyVim.pick("oldfiles")),
			-- dashboard.button("g", " " .. " Find text",       LazyVim.pick("live_grep")),
			-- dashboard.button("c", " " .. " Config",          LazyVim.pick.config_files()),
			-- dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
			-- dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
		}
		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
		end
		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.section.footer.opts.hl = "AlphaFooter"
		dashboard.opts.layout[1].val = 8
		return dashboard
	end,
	config = function(_, dashboard)
		-- close Lazy and re-open when the dashboard is ready
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "AlphaReady",
				callback = function()
					require("lazy").show()
				end,
			})
		end

		require("alpha").setup(dashboard.opts)

		vim.api.nvim_create_autocmd("User", {
			once = true,
			pattern = "LazyVimStarted",
			callback = function()
				local stats = require("lazy").stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
				dashboard.section.footer.val = "⚡ Neovim loaded "
				.. stats.loaded
				.. "/"
				.. stats.count
				.. " plugins in "
				.. ms
				.. "ms"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end,
}
