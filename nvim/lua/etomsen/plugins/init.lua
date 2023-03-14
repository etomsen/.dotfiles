local Plug = require 'usermod.vimplug'

Plug.begin('~/.config/nvim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'nvim-lua/plenary.nvim'
Plug('akinsho/toggleterm.nvim', { tag = "*" })
Plug('folke/todo-comments.nvim', {
    config = function()
        require("todo-comments").setup({
            signs = true,
            fix = {
                icon = "F",
                color = "error",
                alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
            },
            todo = { icon = "T", color = "info", alt = { "TODO", "TASK", "SMELL" } },
            colors = {
                error = { "#DC2626" },
                info = { "#2563EB" }
            }
        })
        vim.api.nvim_set_keymap("n", "<leader>td", "<cmd>TodoTelescope<CR>", {noremap = true, silent = true})
    end
})
Plug('nvim-telescope/telescope.nvim', {
    tag = '0.1.0'
})
Plug('nvim-telescope/telescope-fzf-native.nvim', {run = 'make'})
Plug('xiyaowong/nvim-transparent', {
    config = function()
        vim.g.transparent_enabled = true
    end
})
Plug 'morhetz/gruvbox' 

-- LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'


Plug.ends()

