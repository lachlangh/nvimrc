vim.g.mapleader = " ";
vim.g.maplocalleader = "\\"

-- set 'pv' (previous) to exit in normal mode
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Return to netrw" })

if vim.fn.has("win32") then
    -- needed for powershell which <C-V> pastes to terminal
    vim.keymap.set("n", "<C-q>", "<C-V>", { desc = "Blockwise Visual Mode for Windows terminal" })
end

-- mappings for Cargo commands
vim.keymap.set("n", "<leader>cgr", function() vim.cmd("! cargo run") end, { desc = "Run `cargo run`" })
vim.keymap.set("n", "<leader>cgt", function() vim.cmd("! cargo test --lib") end, { desc = "Run `cargo test --lib`" })

-- helpful for terminal mode and navigating between windows, remap suggestsion from :h terminal-input
vim.api.nvim_set_keymap('t', '<A-h>', '<C-\\><C-N><C-w>h', { desc = "Navigate to the left window in terminal mode" })
vim.api.nvim_set_keymap('t', '<A-j>', '<C-\\><C-N><C-w>j', { desc = "Navigate to down a window in terminal mode" })
vim.api.nvim_set_keymap('t', '<A-k>', '<C-\\><C-N><C-w>k', { desc = "Navigate to up a window in terminal mode" })
vim.api.nvim_set_keymap('t', '<A-l>', '<C-\\><C-N><C-w>l', { desc = "Navigate to the right window in terminal mode" })

-- quickfix movements
vim.keymap.set("n", "<leader>qn", "<Cmd>cnext<CR>", { desc = "Move to the next quickfix item" })
vim.keymap.set("n", "<leader>qp", "<Cmd>cprev<CR>", { desc = "Move to the previous quickfix item" })

-- Splitting & Resizing
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- LSP keymaps
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
            local format_autocmd_id = vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format { bufnr = args.buf, id = client.id }
                end,
            })

            vim.api.nvim_create_user_command("DisableFormatOnSave", function()
                vim.api.nvim_del_autocmd(format_autocmd_id)
                print("Disabled format on save for this session")
            end, {})
        end
    end,
})
