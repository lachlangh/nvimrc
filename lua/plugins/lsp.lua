return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",
    },

    config = function()
        -- For LSP progress notifications
        require("fidget").setup({})

        -- Setup Mason package manager
        require("mason").setup()

        local ensure_installed = {
            "lua_ls",
            "rust_analyzer",
            "air",
        }

        -- on work machine, the mason installation for R lsp requires powershell permissions that
        -- I don't have, so I manually install it. On home machine let mason handle it for me
        if not os.getenv("WORK") then
            ensure_installed = table.insert(ensure_installed, "r_language_server")
        end

        require("mason-lspconfig").setup({
            ensure_installed = ensure_installed,
            automatic_enable = false,
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        vim.lsp.inlay_hint.enable(true)
    end
}
