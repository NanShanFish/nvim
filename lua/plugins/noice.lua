return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        -- add any options here
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
            },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            lsp_doc_border = true, -- add a border to hover docs and signature help
            long_message_to_split = true,
        },
        routes = {
            {
                filter = { event = "msg_show", kind = {"shell_err", "shell_out"} },
                view = "notify",
                opts = {
                    level = 'info',
                    replace = true,
                    title = "shell output"
                }
            }
        }
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        {"MunifTanjim/nui.nvim", event = "VeryLazy"},
        {"rcarriga/nvim-notify", event = "VeryLazy"}
    }

}
