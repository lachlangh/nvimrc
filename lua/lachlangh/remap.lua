vim.g.mapleader = " ";
vim.g.maplocalleader = "\\"

-- set 'pv' (previous) to exit in normal mode
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- needed for powershell which <C-V> pastes to terminal
vim.keymap.set("n", "<C-q>", "<C-V>")

vim.keymap.set("n", "<leader>cgr", function() vim.cmd("! cargo run") end)
vim.keymap.set("n", "<leader>cgt", function() vim.cmd("! cargo test --lib") end)
