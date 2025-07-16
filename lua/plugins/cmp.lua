return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        -- for luasnip support
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        -- for completion pictograms
        "onsails/lspkind.nvim",
    },
    config = function()
        local cmp = require("cmp")
        local lspkind = require("lspkind")
        local cmp_select = { behavior = cmp.SelectBehavior.Select }


        cmp.setup({
            snippet = {
                expand = function(args)
                    local luasnip = require('luasnip')

                    luasnip.config.set_config({
                        history = true,
                        updateevents = "TextChanged,TextChangedI",
                    })

                    luasnip.lsp_expand(args.body) -- For `luasnip` users.

                    vim.keymap.set({ 'i', 's' }, '<C-k>', function()
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            vim.lsp.buf.signature_help()
                        end
                    end, { buffer = 0 })

                    vim.keymap.set({ 'i', 's' }, '<C-j>', function()
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { buffer = 0 })
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
    end

}
