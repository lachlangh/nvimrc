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
