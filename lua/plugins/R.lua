return {
    "R-nvim/R.nvim",
    lazy = false,
    config = function()
        -- Create a table with the options to be passed to setup()
        local R_app
        if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
            R_app = "radian.exe"
        else
            R_app = "radian"
        end


        local opts = {
            hook = {
                on_filetype = function()
                    vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
                    vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
                    vim.api.nvim_buf_set_keymap(0, "n", "<Leader>rtl", "<Plug>RSendAboveLines", {})
                end
            },
            R_app = R_app,
            R_args = { "--quiet", "--no-save" },
            -- min_editor_width = 120,
            bracketed_paste = true,
            rconsole_width = 160,
            disable_cmds = {
                "RClearConsole",
                "RCustomStart",
                "RSPlot",
                "RSaveClose",
            },
        }
        -- Check if the environment variable "R_AUTO_START" exists.
        -- If using fish shell, you could put in your config.fish:
        -- alias r "R_AUTO_START=true nvim"
        if vim.env.R_AUTO_START == "true" then
            opts.auto_start = "on startup"
            opts.objbr_auto_start = true
        end

        vim.api.nvim_create_user_command("RInstallNvimcom", function()
            local plug_path = vim.fn.stdpath("data") .. "/lazy/R.nvim/nvimcom"
            plug_path = vim.uv.fs_realpath(plug_path) or plug_path
            local rpath = (plug_path or ""):gsub("\\", "/")

            local expr = ([[if (!requireNamespace("pak", quietly=TRUE)) install.packages("pak"); pak::pak('local::%s')]])
                :format(rpath)

            vim.system({ "Rscript", "-e", expr }, { text = true }, function(res)
                if res.code == 0 then
                    vim.schedule(function()
                        vim.notify("nvimcom installed successfully via pak", vim.log.levels.INFO)
                    end)
                else
                    vim.schedule(function()
                        vim.notify("nvimcom install failed:\n" .. (res.stderr or res.stdout or ""), vim.log.levels.ERROR)
                    end)
                end
            end)
        end, { desc = "Install the nvimcom R package" })

        require("r").setup(opts)
    end,
}
