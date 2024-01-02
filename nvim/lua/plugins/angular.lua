return {
  "etomsen.angular",
  dir = "../etomsen/angular",
  config = function()
    require("etomsen.angular").setup();
    vim.keymap.set('', '<Leader>at', ': NgOpenTemplate<CR>')
    vim.keymap.set('', '<Leader>ac', ':NgOpenStyle<CR>')
    vim.keymap.set('', '<Leader>as', ':NgOpenSpec<CR>')
    vim.keymap.set('', '<Leader>aj', ':NgOpenComponent<CR>')
    vim.keymap.set('', '<Leader>ad', ':NgShowDirFiles<CR>')
  end
}
