local grp = vim.api.nvim_create_augroup("ConcealForWeb", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = grp,
    pattern = { "html", "javascriptreact", "typescriptreact" },
    callback = function()
        -- window-local option
        vim.wo.conceallevel = 2
        -- Optional: hide while in normal & command-line modes (uncomment if you like)
        -- vim.wo.concealcursor = "nc"
    end,
})


-- Toggle conceallevel 0 <-> 2 for the CURRENT WINDOW
vim.keymap.set("n", "<leader>tc", function()
    local w = vim.wo
    w.conceallevel = (w.conceallevel == 0) and 2 or 0
    vim.notify("conceallevel=" .. w.conceallevel, vim.log.levels.INFO, { title = "Conceal" })
end, { desc = "Toggle conceallevel 0-2 (window-local)" })
