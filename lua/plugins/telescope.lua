return {
    "nvim-telescope/telescope.nvim",

    branch = "0.1.x",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim"
    },

    config = function()
        require('telescope').setup({
            extensions = {
                ["ui-select"] = { require("telescope.themes").get_dropdown {} }
            }
        })

        require('telescope').load_extension('ui-select')

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff',
            function()
                builtin.find_files({
                    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                    hidden = true,
                })
            end
            , { desc = "Telescope all files" })
        vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Telescope git files" })
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, { desc = "Grep inside repo" })
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Telescope buffers" })
    end
}
