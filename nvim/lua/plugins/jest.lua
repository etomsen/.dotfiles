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
            adapters = {
                -- Jest adapter configuration
                ["neotest-jest"] = {
                    jestCommand = "node 'node_modules/.bin/jest'  --",
                    -- jestConfigFile = "jest.config.js", -- adjust if needed
                    cwd = function(path) return vim.fn.getcwd() end,
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

