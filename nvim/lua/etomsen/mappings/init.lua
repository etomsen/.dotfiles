vim.keymap.set('i', 'jk', '<esc>')
vim.keymap.set('', '<leader>lf', ':Lf<CR>')
vim.keymap.set('', '<leader>e', ':vs %:h<CR>')
vim.keymap.set('', '<leader>b', ':vs .<CR>')
vim.keymap.set('', '<leader>f', '<cmd> Telescope find_files<CR>')
vim.keymap.set('', '<leader>g', '<cmd> Telescope live_grep<CR>')
vim.keymap.set('', '<leader>j', '*``cgn') -- replace word under cursor, . = next replace, n = skip
vim.keymap.set('n', '<Leader>cp', ':let @0 = expand("%")<CR>') -- Copy the current buffer's path to your clipboard.
vim.keymap.set('', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>') -- rename a variable
vim.keymap.set('', '<C-Tab>', '<C-w>w') -- Cycle through splits.

--Toggle visually showing all whitespace characters. 
vim.keymap.set('n', '<F7>', ':set list!<CR>', {noremap = true}) 
vim.keymap.set('i', '<F7>', '<C-o>:set list!<CR>', {noremap = true})
vim.keymap.set('c', '<F7>', '<C-o>:set list!<CR>', {noremap = true})

 -- Navigate around splits with a single key combo.
vim.keymap.set('', '<C-l>', '<C-w><C-l>', {noremap = true})
vim.keymap.set('', '<C-h>', '<C-w><C-h>', {noremap = true})
vim.keymap.set('', '<C-k>', '<C-w><C-k>', {noremap = true})
vim.keymap.set('', '<C-j>', '<C-w><C-j>', {noremap = true})

-- Move 1 more lines up or down in normal and visual selection modes.
vim.keymap.set('n', 'K', ':m .-2<CR>==', {noremap = true})
vim.keymap.set('n', 'J', ':m .+1<CR>==', {noremap = true})
vim.keymap.set('v', 'K', ':m \'<-2<CR>gv=gv', {noremap = true})
vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv', {noremap = true})

-- prevent x to override the buffer
vim.keymap.set('n', 'x', '"_x', {noremap = true})
vim.keymap.set('n', 'X', '"_x', {noremap = true})

-- Edit Vim config file in a new tab.
vim.keymap.set('', '<Leader>ev', ':tabnew $MYVIMRC<CR>')

-- Source Vim config file.
vim.keymap.set('', '<Leader>sv', ':source $MYVIMRC<CR>')

 -- Toggle spell check.
vim.keymap.set('', '<F5>', ':setlocal spell!<CR>')
