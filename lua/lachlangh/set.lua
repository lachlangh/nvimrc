-- fat cursor
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.linebreak = true

vim.opt.hidden = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitbelow = true
vim.opt.splitright = true

-- syncronizes system clipboard with nvim clipboard
vim.opt.clipboard = "unnamedplus"

vim.opt.scrolloff = 10

vim.opt.virtualedit = "block"

-- shows subsitution:
vim.opt.inccommand = "split"

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

-- controls the indentation behaviour for R (defaults to aligning
-- with paramter which is very annoying
vim.g.r_indent_align_args = 0

-- Set shell to nushell if on Win32 or Win64
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    vim.opt.shell = "nu"
    -- WARN: disable the usage of temp files for shell commands
    -- because Nu doesn't support `input redirection` which Neovim uses to send buffer content to a command:
    --      `{shell_command} < {temp_file_with_selected_buffer_content}`
    -- When set to `false` the stdin pipe will be used instead.
    -- NOTE: some info about `shelltemp`: https://github.com/neovim/neovim/issues/1008
    vim.opt.shelltemp = false

    -- string to be used to put the output of shell commands in a temp file
    -- 1. when 'shelltemp' is `true`
    -- 2. in the `diff-mode` (`nvim -d file1 file2`) when `diffopt` is set
    --    to use an external diff command: `set diffopt-=internal`
    vim.opt.shellredir = "out+err> %s"

    -- flags for nu:
    -- * `--stdin`       redirect all input to -c
    -- * `--no-newline`  do not append `\n` to stdout
    -- * `--commands -c` execute a command
    vim.opt.shellcmdflag = "--stdin --no-newline -c"

    -- disable all escaping and quoting
    vim.opt.shellxescape = ""
    vim.opt.shellxquote = ""
    vim.opt.shellquote = ""

    -- string to be used with `:make` command to:
    -- 1. save the stderr of `makeprg` in the temp file which Neovim reads using `errorformat` to populate the `quickfix` buffer
    -- 2. show the stdout, stderr and the return_code on the screen
    -- NOTE: `ansi strip` removes all ansi coloring from nushell errors
    vim.opt.shellpipe =
    '| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record'
end
