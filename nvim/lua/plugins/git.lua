return {
  {  "airblade/vim-gitgutter" },
  { "APZelos/blamer.nvim", config = function()
    vim.keymap.set('', '<Leader>bt', ':BlamerToggle<CR>')
  end },
  { "tpope/vim-fugitive" },
  { "homogulosus/vim-diff"},
}
