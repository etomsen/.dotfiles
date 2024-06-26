local function k(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- buffers
k('n', '<A-Tab>', ':bnext<CR>')
k('n', '<A-S-Tab>', ':bprevious<CR>')

-- save and quit
k('n', '<leader>w', ':bd<CR>')
k('n', '<leader>W', ':bd!<CR>')

-- search
k('n', '<leader>nn', ':nohlsearch<CR>')
k('v', '<leader>r', '"hy:%s/<C-r>h//gc<left><left><left>')
k('n', '<leader>r', ':%s//<left>')
k('n', '<leader>wp', 'viwpviwy')

k('i', 'jk', '<esc>')
k('i', 'jj', '<esc>')
k('', '<leader>ls', ':vs %:h<CR>')
k('', '<leader>w', ':bw <CR>') -- close the buffer
k('', '<Leader>W', ':%bd|e# <CR>');
k('', '<leader>j', '*``cgn')                       -- replace word under cursor, . = next replace, n = skip
k('n', '<Leader>cp', ':let @0 = expand("%")<CR>')  -- Copy the current buffer's path to your clipboard.
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

-- Toggle spell check.
k('', '<F5>', ':setlocal spell!<CR>')

-- Quickfix list toggle
k('', '<Leader>qf', function()
    local qf_winid = vim.fn.getqflist({ winid = 0 }).winid;
    local action = qf_winid > 0 and 'cclose' or 'copen';
    vim.cmd('botright '..action);
end)


-- Paste link in markdown format
k('n', '<Leader>K', 'ciw[<C-r>"](<Esc>"*pa )<Esc><CR>', {noremap = true})
k('n', '<Leader>dK', 'di[hvf)p<CR>', {noremap = true})
k('v', '<Leader>K', 'c[<C-r>"](<Esc>"*pa )<Esc><CR>', {noremap = true})


