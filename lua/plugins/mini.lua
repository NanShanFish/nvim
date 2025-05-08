return {
    {
        'echasnovski/mini.ai',
        version = false,
        event = "VeryLazy",
        opts = {},
    },
    {
        'echasnovski/mini.tabline',
        version = false,
        event = {
            "BufAdd",
        },
        opts = {
            show_icons = false
        }
    },
    {
        'echasnovski/mini.pairs',
        version = false,
        event = "InsertEnter",
        opts = {},
    },
    {
        'echasnovski/mini.notify',
        version = false,
        event = "VeryLazy",
        config = function()
            local notify = require('mini.notify')
            notify.setup()
            vim.notify = notify.make_notify({
                ERROR = { duration = 5000 },
                WARN = { duration = 4000 },
                INFO = { duration = 3000 },
            })
        end
    },
}
