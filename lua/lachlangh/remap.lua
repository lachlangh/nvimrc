vim.g.mapleader = " ";
vim.g.maplocalleader = "\\"

-- set 'pv' (previous) to exit in normal mode
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- needed for powershell which <C-V> pastes to terminal
vim.keymap.set("n", "<C-q>", "<C-V>")
