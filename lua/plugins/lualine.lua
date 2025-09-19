return {
    "nvim-lualine/lualine.nvim",
    event = "User NsfLoad",
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
            -- set an empty statusline till lualine loads
            vim.o.statusline = " "
        else
            -- hide the statusline on the starter page
            vim.o.laststatus = 0
        end
    end,
    opts = {
        options = {
            theme = "tokyonight",
            globalstatus = vim.o.laststatus == 3,
            disabled_filetypes = { statusline = { "alpha" } },
            component_separators = '',
            section_separators =  '',
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                "branch"
            },
            lualine_c = {
                {
                    'filename',
                    file_status = false,
                    path = 4
                },
                {
                    "diagnostics",
                    symbols = {
                        error ="✘",
                        warn = "▲",
                        info = "»",
                        hint = "!",
                    },
                },
            },

            lualine_x = {
                {
                    "diff",
                    symbols = {
                        added = "+",
                        modified = "M",
                        removed = "-",
                    },
                },
                {'encoding'},
                {'fileformat'},
            },
            lualine_y = {
                "location",
                "progress"
            },
            lualine_z = {
                function()
                    return " " .. os.date("%R")
                end,
            },
        },
    },
}
