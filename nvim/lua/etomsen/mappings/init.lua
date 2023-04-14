local function k(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- buffers
k('n', '<S-l>', ':bnext<CR>')
k('n', '<S-h>', ':bprevious<CR>')

-- save and quit
k('n', '<leader>s', ':write<CR>')
k('n', '<leader>S', ':wall<CR>')
k('n', '<leader>w', ':bd<CR>')
k('n', '<leader>W', ':bd!<CR>')


-- search
k('n', '<leader>nn', ':nohlsearch<CR>')
k('v', '<C-r>', '"hy:%s/<C-r>h//gc<left><left><left>')

k('i', 'jk', '<esc>')
k('i', 'jj', '<esc>')
k('', '<leader>lf', ':Lf<CR>')
k('', '<leader>e', ':vs %:h<CR>')
k('', '<leader>b', ':vs .<CR>')
k('', '<leader>f', '<cmd> Telescope find_files<CR>')
k('', '<leader>g', '<cmd> Telescope live_grep<CR>')
k('', '<leader>j', '*``cgn')                       -- replace word under cursor, . = next replace, n = skip
k('n', '<Leader>cp', ':let @0 = expand("%")<CR>')  -- Copy the current buffer's path to your clipboard.
k('', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>') -- rename a variable
k('', '<C-Tab>', '<C-w>w')                         -- Cycle through splits.

--Toggle visually showing all whitespace characters.
k('n', '<F7>', ':set list!<CR>', { noremap = true })
k('i', '<F7>', '<C-o>:set list!<CR>', { noremap = true })
k('c', '<F7>', '<C-o>:set list!<CR>', { noremap = true })

-- Navigate around splits with a single key combo.
k('', '<C-l>', '<C-w><C-l>', { noremap = true })
k('', '<C-h>', '<C-w><C-h>', { noremap = true })
k('', '<C-k>', '<C-w><C-k>', { noremap = true })
k('', '<C-j>', '<C-w><C-j>', { noremap = true })

-- Move 1 more lines up or down in normal and visual selection modes.
k('v', 'K', ':m \'<-2<CR>gv=gv', { noremap = true })
k('v', 'J', ':m \'>+1<CR>gv=gv', { noremap = true })

-- prevent x to override the buffer
k('n', 'x', '"_x', { noremap = true })
k('n', 'X', '"_x', { noremap = true })

-- Edit Vim config file in a new tab.
k('', '<Leader>ev', ':tabnew $MYVIMRC<CR>')

-- Source Vim config file.
k('', '<Leader>sv', ':source $MYVIMRC<CR>')

-- Toggle spell check.
k('', '<F5>', ':setlocal spell!<CR>')

-- Diagnostic
k('n', '<space>e', ':lua vim.diagnostic.open_float(0, {scope="line"})<CR>')

-- LSP
k('n', '<space>a', ':lua vim.lsp.buf.code_action()<CR>')
