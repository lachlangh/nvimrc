return {
    "startup-nvim/startup.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" },
    config = function()
        require "startup".setup({ theme = "dashboard" })
        -- for 'startup' filetype we need to disable folds
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "startup",
            callback = function()
                vim.wo.foldenable = false
                vim.wo.foldmethod = "manual"
            end,
        })
    end
}
