local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  "junegunn/fzf",
  "junegunn/fzf.vim",
  "tpope/vim-surround",
  "tpope/vim-commentary",
  "tpope/vim-repeat",
  "airblade/vim-gitgutter",  -- git changes shown inline, integrated with airline
  "vim-airline/vim-airline", -- a bottom bar with info
  "nvim-lua/plenary.nvim",   -- utills
  "ap/vim-buftabline",       -- a top bar with opened buffers
  "ThePrimeagen/harpoon",    -- recent files
  "folke/todo-comments.nvim", -- grep on comments
  { "nvim-telescope/telescope.nvim",            tag = "0.1.4" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  "nvim-telescope/telescope-ui-select.nvim",
  "morhetz/gruvbox",  -- theme
  "stevearc/oil.nvim", -- file management
  -- LSP
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "nvimtools/none-ls.nvim",
  -- Prettier
  "MunifTanjim/prettier.nvim", -- prettier for LSP
  -- vim-wiki
  {
    "vimwiki/vimwiki",
    init = function()
      vim.g.vimwiki_list = { { path = "~/prj/tinkoff/notes", syntax = "markdown", ext = ".md" } }
    end,
  },
  "mtdl9/vim-log-highlighting",
  -- CMP
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  "ray-x/lsp_signature.nvim",
  -- treesitter
  "nvim-treesitter/nvim-treesitter", -- better syntax highlighting
  -- GIT
  "APZelos/blamer.nvim",            -- git blame
  "tpope/vim-fugitive",
  -- TMUX
  "preservim/vimux",               -- tmux
  "joeveiga/ng.nvim",              -- to run tmux from vim
  "christoomey/vim-tmux-navigator", -- to navigate vim splits together with tmux
  "tyewang/vimux-jest-test",       -- tmux jest runner
}
require("lazy").setup(plugins)
