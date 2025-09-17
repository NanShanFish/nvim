return {
    cmd = {'lua-language-server'},
    filetypes = {'lua'},
    root_markers = {'.nvim-root'},
    settings = {
        Lua = {
            hint = {
                enable = true,
            },
            runtime = {
                version = 'LuaJIT',
                path = {'lua/?.lua', 'lua/?/init.lua'},
            },
            diagnostics = {
                globals = {'vim', 'Snacks'},
            },
            telemetry = {
                enable = false,
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
        },
    },
}
