local g = vim.g -- Global variables
local opt = vim.opt -- Set options (global/buffer/windows-scoped)
-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = "a"                               -- Enable mouse support
opt.clipboard = "unnamedplus"                 -- Copy/paste to system clipboard
opt.swapfile = false                          -- Don't use swapfile
opt.completeopt = "menuone,noinsert,noselect" -- Autocomplete options

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true            -- Show line number
opt.showmatch = true         -- Highlight matching parenthesis
opt.foldmethod = "marker"    -- Enable folding (default 'foldmarker')
opt.colorcolumn = "80"       -- Line lenght marker at 80 columns
opt.splitright = true        -- Vertical split to the right
opt.splitbelow = true        -- Horizontal split to the bottom
opt.ignorecase = true        -- Ignore case letters when search
opt.smartcase = true         -- Ignore lowercase for the whole pattern
opt.linebreak = true         -- Wrap on word boundary
opt.termguicolors = true     -- Enable 24-bit RGB colors
opt.laststatus = 3           -- Set global statusline
opt.wrap = false
opt.list = true
opt.listchars = "tab:| ,trail:·"
opt.relativenumber = true

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = false        -- Use spaces instead of tabs
opt.shiftwidth = 4           -- Shift 4 spaces when tab
opt.tabstop = 4              -- 1 tab == 4 spaces
opt.smartindent = true       -- Autoindent new lines
g.autoformat = false         -- Disable format

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true            -- Enable background buffers
opt.history = 100            -- Remember N lines in history
opt.lazyredraw = true        -- Faster scrolling
opt.synmaxcol = 240          -- Max column for syntax highlight
-- opt.updatetime = 250          -- ms to wait for trigger an event

-----------------------------------------------------------
-- Netrwy, CPU
-----------------------------------------------------------
-- vim.g.netrw_banner = 0
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_winsize = 25

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- Disable nvim intro
opt.shortmess:append("sI")
-- Disable builtin plugins
local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
	"tutor",
	"rplugin",
	"synmenu",
	"optwin",
	"compiler",
	"bugreport",
	"ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end

-----------------------------------------------------------
-- Autocmd
-----------------------------------------------------------
-- Python
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python" },
	callback = function()
		vim.bo.expandtab = true
	end,
})

-- C/Cpp
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cpp", "c" },
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
	end,
})

-- Markdown
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	callback = function()
		vim.wo.wrap = true
		vim.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.api.nvim_buf_set_keymap(0, "n", "j", "gj", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(0, "n", "k", "gk", { noremap = true, silent = true })
	end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank({
			higroup = 'Visual',
			timeout = 1500,
		})
	end,
})

-----------------------------------------------------------
-- Different OS
-----------------------------------------------------------
if vim.fn.has("win64") == 1 then
	vim.o.shell = "pwsh.exe"
end

-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------
if vim.g.neovide then
	vim.o.guifont = "Maple Mono NF CN:h14"
	vim.g.neovide_scale_factor = 0.6
	vim.g.neovide_cursor_animation_length = 0.16
	vim.g.neovide_scroll_animation_length = 0.3
	vim.keymap.set({ "n", "v" }, "<C-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
	vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
	vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = 0.6<CR>")
end
