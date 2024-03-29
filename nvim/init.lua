-- Author: Evgeny Tomsen
-- repo  : https://github.com/etomsen/dotfiles/

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

require "options"
require "mappings"
require("lazy").setup("plugins")
-- load all mappings from all the loaded plugins
require('langmapper').automapping({ global = true, buffer = true })
