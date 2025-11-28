local g = vim.g -- Global variables
local opt = vim.opt -- Set options (global/buffer/windows-scoped)
-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = "a"      -- Enable mouse support
opt.clipboard = "unnamedplus"   -- Copy/paste to system clipboard
opt.swapfile = false    -- Don't use swapfile
opt.completeopt = "menuone,noinsert,noselect" -- Autocomplete options
vim.o.undofile = true
vim.env.PATH = "/home/shan/.local/share/nvim/mason/bin/:" .. vim.env.PATH
-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true   -- Show line number
opt.showmatch = true   -- Highlight matching parenthesis
opt.foldmethod = "marker" -- Enable folding (default 'foldmarker')
opt.colorcolumn = "80"  -- Line lenght marker at 80 columns
opt.splitright = true  -- Vertical split to the right
opt.splitbelow = true  -- Horizontal split to the bottom
opt.ignorecase = true  -- Ignore case letters when search
opt.smartcase = true   -- Ignore lowercase for the whole pattern
opt.linebreak = true   -- Wrap on word boundary
opt.termguicolors = true  -- Enable 24-bit RGB colors
opt.laststatus = 0   -- Set global statusline
opt.wrap = false
opt.list = true
opt.listchars = "tab:| ,trail:·"
opt.relativenumber = true
vim.o.cmdheight = 0
vim.diagnostic.enable = true
vim.o.winborder = "single"
-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true  -- Use spaces instead of tabs
opt.shiftwidth = 4   -- Shift 4 spaces when tab
opt.tabstop = 4   -- 1 tab == 4 spaces
opt.smartindent = true  -- Autoindent new lines
g.autoformat = false   -- Disable format

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true   -- Enable background buffers
opt.history = 100   -- Remember N lines in history
-- opt.lazyredraw = true  -- Faster scrolling
opt.synmaxcol = 240  -- Max column for syntax highlight
-- opt.updatetime = 250  -- ms to wait for trigger an event

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
-- Plugins
-----------------------------------------------------------
-- if vim.g.neovide then
-- 	vim.o.guifont = "Maple Mono NF CN:h14"
-- 	vim.g.neovide_scale_factor = 0.6
-- 	vim.g.neovide_cursor_animation_length = 0.16
-- 	vim.g.neovide_scroll_animation_length = 0.3
-- 	vim.keymap.set({ "n", "v" }, "<C-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
-- 	vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
-- 	vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = 0.6<CR>")
-- end
