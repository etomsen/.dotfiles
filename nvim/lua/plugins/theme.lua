return {
    {
        "morhetz/gruvbox",
    },
    {
        "Mofiqul/vscode.nvim",
    },
    {"catppuccin/nvim", name = "catppuccin", config = function()
        require("catppuccin").setup({
            flavour = "latte", -- latte, frappe, macchiato, mocha
            background = { -- :h background
                light = "latte",
                dark = "mocha",
            },
        })
        vim.cmd([[silent! colorscheme vscode]])
    end}
}
