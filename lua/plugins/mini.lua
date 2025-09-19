return {
    {
        'echasnovski/mini.ai',
        version = false,
        event = "User NsfLoad",
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
        enabled = false,
        event = "InsertEnter",
        opts = {},
    },
    {
        "nvim-mini/mini.surround",
        version = false,
        opts = {
            mappings = {
                add = 'Sa', -- Add surrounding in Normal and Visual modes
                delete = 'Sd', -- Delete surrounding
                find = 'Sf', -- Find surrounding (to the right)
                find_left = 'SF', -- Find surrounding (to the left)
                highlight = 'Sh', -- Highlight surrounding
                replace = 'Sr', -- Replace surrounding
            }
        },
        event = "User NsfLoad"
    },
}
