return {
    {
        "morhetz/gruvbox",
    },
    {
        "Mofiqul/vscode.nvim",
    },
    {"catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000, config = function()
        require("catppuccin").setup({
            flavour = "frappe", -- latte, frappe, macchiato, mocha
            background = { -- :h background
                light = "latte",
                dark = "mocha",
            },
        })
        vim.cmd([[silent! colorscheme catppuccin]])
    end}
}
