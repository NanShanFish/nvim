return {
    name = "basedpyright",

    filetypes = { "python" },
    cmd = { "basedpyright-langserver", "--stdio" },
    root_markers = { ".git", ".pyproject.toml", },
    settings = {
        python = {
            "./.venv",
        },
        basedpyright = {
            disableOrganizeImports = true,
            analysis = {
                autoSearchPaths = true,
                autoImportCompletions = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "recommended",
                inlayHints = {
                    variableTypes = true,
                    callArgumentNames = true,

                    functionReturnTypes = true,
                    genericTypes = false,
                },
            },
        },
    },
}
