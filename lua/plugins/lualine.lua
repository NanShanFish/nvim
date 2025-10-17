return {
    "nvim-lualine/lualine.nvim",
    event = "User NsfLoad",
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
    end,
    opts = {
        options = {
            theme = "tokyonight",
            globalstatus = vim.o.laststatus == 3,
            component_separators = '',
            section_separators =  { left = '▓▒░', right ='░▒▓' },
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
                    "diff",
                    symbols = {
                        added = "+",
                        modified = "~",
                        removed = "-",
                    },
                },
                function ()
                    local recording_register = vim.fn.reg_recording()
                    if recording_register == "" then
                        return ""
                    else
                        return "Recording @" .. recording_register
                    end
                end,
            },

            lualine_x = {
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
            lualine_y = {
                'encoding',
                'fileformat',
            },
            lualine_z = {
                "progress"
            },
        },
    },
}
