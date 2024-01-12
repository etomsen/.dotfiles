return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            local telescope_builtin = require('telescope.builtin')
            vim.keymap.set("n", "<leader>f", "<cmd> Telescope find_files<CR>")
            vim.keymap.set('n', "<leader>g", "<cmd> Telescope live_grep<CR>")
            vim.keymap.set('v', "<leader>g", "y<ESC>:Telescope live_grep default_text=<c-r>0<CR>", {noremap = true, silent = true})
            vim.keymap.set('n', "<leader>gg", "yiw<ESC>:Telescope live_grep default_text=<c-r>0<CR>", {noremap = true, silent = true})
            vim.keymap.set('n', "<leader>q", "<cmd> Telescope quickfix<CR>", {noremap = true, silent = true})
            vim.keymap.set('n', "<leader>qh", "<cmd> Telescope quickfixhistory<CR>", {noremap = true, silent = true})
            vim.keymap.set('n', "gd", "<cmd>Telescope lsp_definitions<CR>")
            vim.keymap.set('n', "<leader>lf", function()
                telescope_builtin.treesitter{default_text="function"}
            end)
            vim.keymap.set('n', "<leader>lr", "yiw<ESC>:Telescope lsp_references default_text=<c-r>0<CR>")
        end
    },
    -- {
    --   "nvim-telescope/telescope-fzf-native.nvim",
    --   build = 'make',
    --   dependencies = {
    --     "nvim-lua/plenary.nvim"
    --   },
    --   config = function()
    --     require("telescope").setup({
    --       extensions = {
    --         fzf = {
    --           fuzzy = true
    --         }
    --       }
    --     })
    --     require("telescope").load_extension("fzf")
    --   end
    -- },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = require("telescope.themes").get_dropdown({}),
                },
            })
            require("telescope").load_extension("ui-select")
        end
    }
}
