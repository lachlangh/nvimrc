-- set some better defaults for R
local set = vim.opt_local

set.shiftwidth = 2
set.tabstop = 2
set.expandtab = true

set.textwidth = 100            -- good width for comments
set.formatoptions:append("or") -- auto continue comment character on next line
