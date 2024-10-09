return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "R-nvim/R.nvim",
        "R-nvim/cmp-r",
        "onsails/lspkind.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "r_language_server",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,

                ["r_language_server"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.r_language_server.setup {
                        capabilities = capabilities,
                        on_attach    = function(_, bufnr)
                            -- Set up indentation to 2 spaces
                            vim.api.nvim_buf_set_option(bufnr, "shiftwidth", 2)
                            vim.api.nvim_buf_set_option(bufnr, "tabstop", 2)
                            vim.api.nvim_buf_set_option(bufnr, "expandtab", true)
                        end,
                        settings     = { r = { lsp = { debug = false } } },
                    }
                end
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        local lspkind = require('lspkind')

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
                { name = "cmp_r" },
            }, {
                { name = 'buffer' },
            }),
            formatting = {
                format = lspkind.cmp_format({})
            }
        })

        require("cmp_r").setup({})

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

        -- Global LSP key mappings (on LSP attach)
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
            callback = function(event)
                local opts = { buffer = event.buf }

                vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
                vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
                vim.keymap.set('n', '<leader>fm', function() vim.lsp.buf.format() end, opts)

                -- auto format on save when attached to lsp server
                vim.api.nvim_create_autocmd("BufWritePre", {
                    -- 3
                    buffer = event.buf,
                    callback = function()
                        -- 4 + 5
                        vim.lsp.buf.format { async = false, id = event.data.client_id }
                    end,
                })
            end,
        })

        vim.lsp.inlay_hint.enable(true)
    end
}
