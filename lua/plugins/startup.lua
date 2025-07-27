return {
    "startup-nvim/startup.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" },
    config = function()
        require "startup".setup({ theme = "dashboard" })

        -- create an augroup so we can clear/reload safely
        local fold_grp = vim.api.nvim_create_augroup("StartupFolding", { clear = true })

        -- when the dashboard opens, stash the window’s fold settings and disable folding
        vim.api.nvim_create_autocmd("FileType", {
            group = fold_grp,
            pattern = "startup",
            callback = function()
                vim.b.startup_old = {
                    method = vim.wo.foldmethod,
                    enable = vim.wo.foldenable,
                    level  = vim.wo.foldlevel,
                }
                vim.b.is_startup  = true

                vim.wo.foldmethod = "manual"
                vim.wo.foldenable = false
                vim.wo.foldlevel  = 99
            end,
        })

        -- when you leave that buffer, restore the previous fold settings
        vim.api.nvim_create_autocmd("BufWinLeave", {
            group = fold_grp,
            pattern = "*",
            callback = function()
                if vim.b.is_startup and vim.b.startup_old then
                    local old         = vim.b.startup_old
                    vim.wo.foldmethod = old.method
                    vim.wo.foldenable = old.enable
                    vim.wo.foldlevel  = old.level
                    vim.b.is_startup  = nil
                    vim.b.startup_old = nil
                end
            end,
        })
    end,
}
