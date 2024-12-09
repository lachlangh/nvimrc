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
        "hrsh7th/cmp-nvim-lua",
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

        local ensure_installed = {
            "lua_ls",
            "rust_analyzer",
        }

        -- on work machine, the mason installation for R lsp requires powershell permissions that
        -- I don't have, so I manually install it. On home machine let mason handle it for me
        if not os.getenv("WORK") then
            ensure_installed = table.insert(ensure_installed, "r_language_server")
        end

        require("mason-lspconfig").setup({
            ensure_installed = ensure_installed,

            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        on_init = function(client)
                            if client.workspace_folders then
                                local path = client.workspace_folders[1].name
                                if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                                    return
                                end
                            end
                            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                                runtime = {
                                    -- Tell the language server which version of Lua you're using
                                    -- (most likely LuaJIT in the case of Neovim)
                                    version = 'LuaJIT'
                                },
                                -- Make the server aware of Neovim runtime files
                                workspace = {
                                    checkThirdParty = false,
                                    library = {
                                        vim.env.VIMRUNTIME
                                        -- Depending on the usage, you might want to add additional paths here.
                                        -- "${3rd}/luv/library"
                                        -- "${3rd}/busted/library",
                                    }
                                }
                            })
                        end,
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

                ["pyright"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pyright.setup {
                        capabilities = capabilities,
                    }
                end,

                ["rust_analyzer"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.rust_analyzer.setup {
                        capabilities = capabilities,
                        settings = {
                            ["rust-analyzer"] = {
                                imports = {
                                    granularity = {
                                        group = "module",
                                    },
                                    prefix = "self",
                                },
                                cargo = {
                                    buildScripts = {
                                        enable = true,
                                    },
                                },
                                procMacro = {
                                    enable = true
                                },
                            }
                        }
                    }
                end,

                ["r_language_server"] = function()
                    if not os.getenv("WORK") then
                        local lspconfig = require("lspconfig")
                        lspconfig.r_language_server.setup {
                            capabilities = capabilities,
                            settings     = { r = { lsp = { debug = false } } },
                        }
                    end
                end
            }

        })

        if os.getenv("WORK") then
            require("lspconfig").r_language_server.setup({
                capabilities = capabilities,
                settings     = { r = { lsp = { debug = false, rich_documentation = false } }
                },
            })
        end

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
                { name = 'nvim_lua' },
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
            callback = function(args)
                local opts = { buffer = args.buf }
                local client = vim.lsp.get_client_by_id(args.data.client_id)

                if not client then return end

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

                if client.supports_method('textDocument/formatting') then
                    vim.keymap.set('n', '<leader>fm', function() vim.lsp.buf.format() end, opts)

                    -- auto format on save when attached to lsp server
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format { bufnr = args.buf, id = client.id }
                        end,
                    })
                end
            end,
        })

        vim.lsp.inlay_hint.enable(true)
    end
}
