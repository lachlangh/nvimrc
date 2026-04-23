local function set_smart_foldmethod()
    local bufnr = vim.api.nvim_get_current_buf()
    local winid = vim.api.nvim_get_current_win()

    local bo = vim.bo[bufnr]
    local wo = vim.wo[winid]

    -- Ignore special buffers
    if bo.buftype ~= "" then
        wo.foldmethod = "manual"
        return
    end

    -- Use indent folding for R files
    if bo.filetype == "r" then
        wo.foldmethod = "indent"
        wo.foldexpr = "0"
    else
        -- Use Treesitter folding where available
        local ok = pcall(vim.treesitter.get_parser, bufnr)
        if ok then
            wo.foldmethod = "expr"
            wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        else
            wo.foldmethod = "indent"
            wo.foldexpr = "0"
        end
    end

    wo.foldlevel = 0
    wo.foldcolumn = "2"
end

vim.api.nvim_create_autocmd({ "FileType" }, {
    callback = set_smart_foldmethod,
})
