return {
    -- Core neotest framework (with required dependencies)
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/neotest-jest",
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            icons = {
                passed = "+",
                failed = "x",
                running = "~",
                skipped = "-",
                unknown = "?",
                non_collapsible = " ",
                collapsed = ">",
                expanded = "v",
                child_prefix = " ",
                child_indent = " ",
                final_child_prefix = " ",
                final_child_indent = " ",
            },
            adapters = {
                -- Jest adapter configuration
                ["neotest-jest"] = {
                    jestCommand = "node_modules/.bin/jest",
                    jestConfigFile = function(file)
                        local dir = vim.fn.fnamemodify(file, ":h")
                        while dir ~= "/" do
                            for _, name in ipairs({ "jest.config.cts", "jest.config.ts", "jest.config.js", "jest.config.cjs" }) do
                                local config = dir .. "/" .. name
                                if vim.fn.filereadable(config) == 1 then
                                    return config
                                end
                            end
                            dir = vim.fn.fnamemodify(dir, ":h")
                        end
                        return vim.fn.getcwd() .. "/jest.config.ts"
                    end,
                    cwd = function() return vim.fn.getcwd() end,
                },
            },
            status = { virtual_text = true },
            output = { open_on_run = true },
            quickfix = {
                open = function()
                    if require("lazy.core.config").plugins["trouble.nvim"] then
                        require("trouble").open({ mode = "quickfix", focus = false })
                    else
                        vim.cmd("copen")
                    end
                end,
            },
        },
        config = function(_, opts)
            -- Patch: don't escape slashes in file paths (breaks Jest 30 path matching)
            local jest_util = require("neotest-jest.util")
            local original_escape = jest_util.escapeTestPattern
            jest_util.escapeTestPattern = function(s)
                if s:match("^/") or s:match("^%a:\\") then
                    return s
                end
                return original_escape(s)
            end

            local neotest = require("neotest")
            local adapters = {}
            for name, config in pairs(opts.adapters or {}) do
                local adapter = require(name)(config)
                table.insert(adapters, adapter)
            end
            opts.adapters = adapters
            neotest.setup(opts)

            vim.api.nvim_create_user_command("Jest", function()
                neotest.run.run(vim.fn.expand("%"))
                neotest.summary.open()
            end, { desc = "Run Jest tests for current file" })
        end,
        keys = {
            { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: Run File" },
            { "<leader>tr", function() require("neotest").run.run() end, desc = "Test: Run Nearest" },
            { "<leader>ta", function() require("neotest").run.run({ suite = true }) end, desc = "Test: Run Suite" },
            { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test: Toggle Summary" },
            { "<leader>to", function() require("neotest").output.open() end, desc = "Test: Show Output" },
        },
    },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-neotest/nvim-nio" },
}

