-- LSP Support
local M = {}

local lsp_attach = function(client, bufnr)
	print("lsp attached!")
end

local on_init = function(client, bufnr)
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

local function quit_floating_win()
	local win_id = vim.api.nvim_get_current_win()
	local config = vim.api.nvim_win_get_config(win_id)
	local flag = config.relative ~= ""
	if flag then
		vim.api.nvim_win_close(win_id, true)
	end
end

M = {
	-- LSP Configuration
	-- https://github.com/neovim/nvim-lspconfig
	"neovim/nvim-lspconfig",
    -- event = "LazyFile",
    lazy = false,
	dependencies = {
		-- LSP Management
		-- https://github.com/williamboman/mason.nvim
		{ "williamboman/mason.nvim" },
		-- https://github.com/williamboman/mason-lspconfig.nvim
		{ "williamboman/mason-lspconfig.nvim" },

		-- Auto-Install LSPs, linters, formatters, debuggers
		-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
		-- { "WhoIsSethDaniel/mason-tool-installer.nvim" },

		-- Useful status updates for LSP
		-- https://github.com/j-hui/fidget.nvim
		-- { "j-hui/fidget.nvim", opts = {} },

		-- Additional lua configuration, makes nvim stuff amazing!
		-- https://github.com/folke/neodev.nvim
		-- { 'folke/neodev.nvim',                        opts = {} },
		{ "folke/lazydev.nvim" },
		-- { "saghen/blink.cmp" },
		-- schemas
		-- { "b0o/schemastore.nvim" },
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				-- bash
				"bashls",

				-- markdown
				"marksman",


				-- python
				"basedpyright",

				--- c, cpp
				"clangd",

				-- lua
				"lua_ls",
			},
			automatic_installation = false,
		})

		-- require("mason-tool-installer").setup({
		-- 	-- Install these linters, formatters, debuggers automatically
		-- 	ensure_installed = {
		-- 		-- python
		-- 		"black",
		-- 		"isort",
		-- 		"debugpy",
		-- 		"flake8",
		-- 		"mypy",
		-- 		"pylint",
		-- 		"djlint",
		--
		-- 		-- cpp
		-- 		"clang-format",
		--
		-- 		-- javascript formatter
		-- 		"prettier",
		-- 		"prettierd",
		-- 	},
		-- })

		-- There is an issue with mason-tools-installer running with VeryLazy, since it triggers on VimEnter which has already occurred prior to this plugin loading so we need to call install explicitly
		-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39
		-- vim.api.nvim_command("MasonToolsInstall")

		local lspconfig = require("lspconfig")
		local lsp_capabilities = require("blink.cmp").get_lsp_capabilities()
		-- local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Call setup on each LSP server
		require("mason-lspconfig").setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					on_attach = lsp_attach,
					capabilities = lsp_capabilities,
				})
			end,
			-- ["svelte"] = function()
			-- 	-- configure svelte server
			-- 	lspconfig["svelte"].setup({
			-- 		capabilities = lsp_capabilities,
			-- 		on_attach = function(client, bufnr)
			-- 			vim.api.nvim_create_autocmd("BufWritePost", {
			-- 				pattern = { "*.js", "*.ts" },
			-- 				callback = function(ctx)
			-- 					-- Here use ctx.match instead of ctx.file
			-- 					client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
			-- 				end,
			-- 			})
			-- 		end,
			-- 	})
			-- end,
			-- ["graphql"] = function()
			-- 	-- configure graphql language server
			-- 	lspconfig["graphql"].setup({
			-- 		capabilities = lsp_capabilities,
			-- 		filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
			-- 	})
			-- end,
			-- ["emmet_ls"] = function()
			-- 	-- configure emmet language server
			-- 	lspconfig["emmet_ls"].setup({
			-- 		capabilities = lsp_capabilities,
			-- 		filetypes = {
			-- 			"html",
			-- 			"htmldjango",
			-- 			"typescriptreact",
			-- 			"javascriptreact",
			-- 			"css",
			-- 			"sass",
			-- 			"scss",
			-- 			"less",
			-- 			"svelte",
			-- 		},
			-- 	})
			-- end,

			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = lsp_capabilities,
					on_init = on_init,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							hint = {
								enable = true,
								arrayIndex = "Enable",
								await = true,
								paramName = "All",
								paramType = true,
								semicolon = "All",
								setType = true,
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = true,
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
			["marksman"] = function()
				lspconfig["marksman"].setup({
					capabilities = lsp_capabilities,
					filetypes = { "markdown" },
				})
			end,

			-- ["basedpyright"] = function()
			-- 	lspconfig["basedpyright"].setup({
			-- 		capabilities = lsp_capabilities,
			-- 		settings = {
			-- 			basedpyright = {
			-- 				typeCheckingMode = "basic",
			-- 				analysis = {
			-- 					diagnosticMode = "openFilesOnly",
			-- 				},
			-- 			},
			-- 		},
			-- 	})
			-- end,

			-- ["pyright"] = function()
			-- 	-- config python server with special setting
			--
			-- 	lspconfig.pyright.setup({
			-- 		capabilities = {
			-- 			codeActionProvider = true,
			-- 		},
			-- 		settings = {
			-- 			python = {
			-- 				analysis = {
			-- 					typeCheckingMode = "basic",
			-- 					autoSeachPaths = true,
			-- 				},
			-- 			},
			-- 		},
			-- 	})
			-- end,
		})

		-- lspconfig.pyright.setup({
		-- 	-- cmd = { vim.fn.stdpath("config") .. "/lsp/node_modules/.bin/pyright-langserver", "--stdio" },
		-- 	cmd = { vim.fn.stdpath("config") .. "/lsp/node_modules/.bin/delance-langserver", "--stdio" },
		-- 	capabilities = {
		-- 		codeActionProvider = true,
		-- 	},
		-- 	settings = {
		-- 		python = {
		-- 			analysis = {
		-- 				typeCheckingMode = "basic",
		-- 				autoSeachPaths = true,
		-- 			},
		-- 		},
		-- 	},
		-- })

		lspconfig["basedpyright"].setup({
			capabilities = lsp_capabilities,
			on_init = on_init,
			settings = {
				basedpyright = {
					typeCheckingMode = "basic",
					analysis = {
						diagnosticMode = "openFilesOnly",
						strictGenericNarrowing = true,
						inlayHints = {
							variableTypes = true,
							callArgumentNames = true,
							functionReturnTypes = true,
							genericTypes = true,
						},
					},
				},
			},
		})
		--
		-- lspconfig["jsonls"].setup({
		-- 	capabilities = lsp_capabilities,
		-- 	on_attach = lsp_attach,
		-- 	filetypes = { "json", "jsonc" },
		-- 	settings = {
		-- 		http = {
		-- 			proxy = "127.0.0.1:7897",
		-- 			proxyStrictSSL = true,
		-- 		},
		-- 		json = {
		-- 			schemas = require("schemastore").json.schemas(),
		-- 			validate = { enable = true },
		-- 		},
		-- 	},
		-- })
		--
		-- lspconfig["ts_ls"].setup({
		-- 	capabilities = lsp_capabilities,
		-- 	on_attach = lsp_attach,
		-- 	init_options = {
		-- 		plugins = {
		-- 			{
		-- 				name = "@vue/typescript-plugin",
		-- 				location = vim.fn.stdpath("data")
		-- 					.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
		-- 				languages = { "vue" },
		-- 			},
		-- 		},
		-- 	},
		-- 	-- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		-- 	settings = {
		-- 		typescript = {
		-- 			tsserver = {
		-- 				useSyntaxServer = true,
		-- 			},
		-- 			inlayHints = {
		-- 				includeInlayParameterNameHints = "all",
		-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
		-- 				includeInlayFunctionParameterTypeHints = true,
		-- 				includeInlayVariableTypeHints = true,
		-- 				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
		-- 				includeInlayPropertyDeclarationTypeHints = true,
		-- 				includeInlayFunctionLikeReturnTypeHints = true,
		-- 				includeInlayEnumMemberValueHints = true,
		-- 			},
		-- 		},
		-- 	},
		-- })
		--
		-- lspconfig["volar"].setup({
		-- 	capabilities = lsp_capabilities,
		-- 	on_attach = lsp_attach,
		-- 	on_init = on_init,
		-- 	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		-- 	init_options = {
		-- 		vue = {
		-- 			hybridMode = false,
		-- 		},
		-- 	},
		-- 	settings = {
		-- 		typescript = {
		-- 			inlayHints = {
		-- 				enumMemberValues = {
		-- 					enabled = true,
		-- 				},
		-- 				functionLikeReturnTypes = {
		-- 					enabled = true,
		-- 				},
		-- 				propertyDeclarationTypes = {
		-- 					enabled = true,
		-- 				},
		-- 				parameterTypes = {
		-- 					enabled = true,
		-- 					suppressWhenArgumentMatchesName = true,
		-- 				},
		-- 				variableTypes = {
		-- 					enabled = true,
		-- 				},
		-- 			},
		-- 		},
		-- 	},
		-- })

		-- lspconfig["cssls"].setup({
		-- 	capabilities = lsp_capabilities,
		-- 	on_attach = lsp_attach,
		-- })

		-- lspconfig["emmet_ls"].setup({
		-- 	filetypes = {
		-- 		"html",
		-- 		"typescriptreact",
		-- 		"javascriptreact",
		-- 		"css",
		-- 		"sass",
		-- 		"scss",
		-- 		"less",
		-- 		"vue",
		-- 		"django-html", -- add your custom filetypes
		-- 	},
		-- 	init_options = {
		-- 		html = {
		-- 			options = {
		-- 				-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
		-- 				["bem.enabled"] = true,
		-- 			},
		-- 		},
		-- 	},
		-- })

		-- -- Lua LSP settings
		-- lspconfig.lua_ls.setup {
		--   settings = {
		--     Lua = {
		--       diagnostics = {
		--         -- Get the language server to recognize the `vim` global
		--         globals = { 'vim' },
		--       },
		--     },
		--   },
		-- }
		--
		-- markdown LSP settings
		-- setup() is also available as an alias
		-- require("lspkind").init({
		-- 	-- DEPRECATED (use mode instead): enables text annotations
		-- 	--
		-- 	-- default: true
		-- 	-- with_text = true,
		--
		-- 	-- defines how annotations are shown
		-- 	-- default: symbol
		-- 	-- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
		-- 	mode = "symbol_text",
		--
		-- 	-- default symbol map
		-- 	-- can be either 'default' (requires nerd-fonts font) or
		-- 	-- 'codicons' for codicon preset (requires vscode-codicons font)
		-- 	--
		-- 	-- default: 'default'
		-- 	preset = "codicons",
		--
		-- 	-- override preset symbols
		-- 	--
		-- 	-- default: {}
		-- 	symbol_map = {
		-- 		Text = "󰉿",
		-- 		Method = "󰆧",
		-- 		Function = "󰊕",
		-- 		Constructor = "",
		-- 		Field = "󰜢",
		-- 		Variable = "󰀫",
		-- 		Class = "󰠱",
		-- 		Interface = "",
		-- 		Module = "",
		-- 		Property = "󰜢",
		-- 		Unit = "󰑭",
		-- 		Value = "󰎠",
		-- 		Enum = "",
		-- 		Keyword = "󰌋",
		-- 		Snippet = "",
		-- 		Color = "󰏘",
		-- 		File = "󰈙",
		-- 		Reference = "󰈇",
		-- 		Folder = "󰉋",
		-- 		EnumMember = "",
		-- 		Constant = "󰏿",
		-- 		Struct = "󰙅",
		-- 		Event = "",
		-- 		Operator = "󰆕",
		-- 		TypeParameter = "",
		-- 	},
		-- })

		-- it is the same shortcut in coc, I may addd this to the overall config
		vim.keymap.set("n", "<Esc>", quit_floating_win, { noremap = true, silent = true })
		-- Globally configure all LSP floating preview popups (like hover, signature help, etc)
		local open_floating_preview = vim.lsp.util.open_floating_preview
		local function my_open_floating_preview(contents, syntax, opts)
			opts = opts or {}
			opts.border = opts.border or "single" -- Set border to rounded
			return open_floating_preview(contents, syntax, opts)
		end
		vim.lsp.util.open_floating_preview = my_open_floating_preview
	end,
}
return M
