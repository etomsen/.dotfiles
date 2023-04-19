local Plug = require 'usermod.vimplug'

Plug.begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'nvim-lua/plenary.nvim'
Plug 'ap/vim-buftabline'
Plug('akinsho/toggleterm.nvim', { tag = "*" })
Plug('folke/todo-comments.nvim')
Plug('nvim-telescope/telescope.nvim', {
  tag = '0.1.0'
})
Plug('nvim-telescope/telescope-fzf-native.nvim', { run = 'make' })
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
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'ray-x/lsp_signature.nvim'
Plug 'joeveiga/ng.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug.ends()
