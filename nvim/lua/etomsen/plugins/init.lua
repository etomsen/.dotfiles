local Plug = require 'usermod.vimplug'

Plug.begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'airblade/vim-gitgutter' -- git changes shown inline, integrated with airline
Plug 'vim-airline/vim-airline' -- a bottom bar with info
Plug 'nvim-lua/plenary.nvim' -- utills
Plug 'ap/vim-buftabline' -- a top bar with opened buffers
Plug 'ThePrimeagen/harpoon' -- recent files
Plug('folke/todo-comments.nvim') -- grep on comments
Plug('nvim-telescope/telescope.nvim', {
  tag = '0.1.0'
})
Plug('nvim-telescope/telescope-fzf-native.nvim', { run = 'make' })
Plug 'morhetz/gruvbox' -- theme
Plug 'stevearc/oil.nvim' -- file management

-- LSP and syntax
Plug 'neovim/nvim-lspconfig'
Plug 'MunifTanjim/prettier.nvim' -- prettier for LSP
Plug 'folke/neodev.nvim' -- nvim dev helpers for LSP
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'ray-x/lsp_signature.nvim'
Plug ('nvim-treesitter/nvim-treesitter') -- better syntax highlighting

-- GIT
Plug 'APZelos/blamer.nvim' -- git blame
Plug 'tpope/vim-fugitive'

-- TMUX
Plug 'preservim/vimux' -- tmux
Plug 'joeveiga/ng.nvim' -- to run tmux from vim
Plug 'christoomey/vim-tmux-navigator' -- to navigate vim splits together with tmux
Plug 'tyewang/vimux-jest-test' -- tmux jest runner

Plug.ends()
