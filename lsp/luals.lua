return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".git", vim.uv.cwd() },
    settings = {
        Lua = {
            hint = {
                enable = true,
            },
            telemetry = {
                enable = false,
            },
        },
    },

}
