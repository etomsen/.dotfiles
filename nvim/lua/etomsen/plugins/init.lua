local Plug = require 'usermod.vimplug'

Plug.begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'kyazdani42/nvim-tree.lua' -- navigation
-- Plug 'Yggdroot/indentLine' -- vertical indentation lines, substituted by blankline
Plug 'airblade/vim-gitgutter' -- git changes shown inline, integrated with airline
Plug 'vim-airline/vim-airline' -- a bottom bar with info
Plug 'lukas-reineke/indent-blankline.nvim'
-- Plug 'HerringtonDarkholme/yats.vim' -- typescript syntax fix and more... but way too heavy
Plug 'nvim-lua/plenary.nvim'
Plug ('nvim-treesitter/nvim-treesitter')
Plug 'ThePrimeagen/harpoon' -- recent files
Plug 'ap/vim-buftabline' -- a top bar with opened buffers
Plug('akinsho/toggleterm.nvim', { tag = "*" }) -- an intergrated termninal with toggle
Plug('folke/todo-comments.nvim') -- grep on comments
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
Plug 'MunifTanjim/prettier.nvim' -- prettier for LSP
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'ray-x/lsp_signature.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'APZelos/blamer.nvim' -- git blame
Plug 'preservim/vimux' -- tmux
Plug 'joeveiga/ng.nvim' -- to run tmux from vim
Plug 'christoomey/vim-tmux-navigator' -- to navigate vim splits together with tmux
Plug 'tyewang/vimux-jest-test' -- tmux jest runner
Plug.ends()
