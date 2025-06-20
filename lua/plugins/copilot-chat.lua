return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "github/copilot.vim" },                       -- or zbirenbaum/copilot.lua
            { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        },
        opts = {
            -- See Configuration section for options
        },
        init = function()
            vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChat<cr>", {
                desc = "Copilot Chat",
            })
        end
        -- See Commands section for default commands if you want to lazy load on them
    },
}
