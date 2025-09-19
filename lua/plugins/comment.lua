return {
    {
        "folke/ts-comments.nvim",
        opts = {},
        event = "User NsfLoad",
        enabled = vim.fn.has("nvim-0.10.0") == 1,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim", event = "User NsfLoad"},
        },
        event = "User NsfLoad",
        opts = { }
    }
}
