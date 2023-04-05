local set = vim.opt

set.modifiable = true
set.mouse = "a"
set.re = 2 -- to remove the readrawtime exceeded error with *.ts(x) files
set.encoding = "utf-8"
set.number = true
set.relativenumber = true
set.scrolloff = 7
set.expandtab = true
set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
set.expandtab = true
set.autoindent = true
set.fileformat = "unix"
set.smartindent = true
set.foldmethod = 'indent' -- set the code folding
set.path['**'] = true -- search into subfolders by :find command (also supports wildcard)
set.wildmenu = true -- display matching files, use :b to list files in a buffer
set.splitbelow = true
set.splitright = true

vim.g.mapleader = ","
vim.g.netrw_banner = 0 -- hide banner above files
vim.g.netrw_browse_split = 0 -- close after selecting a file
vim.g.netrw_altv = 1 -- open splits to the right
vim.g.netrw_liststyle = 3 -- tree view
vim.g.netrw_list_hide = (vim.fn["netrw_gitignore#Hide"]()) .. [[,\(^\|\s\s\)\zs\.\S\+]] -- use .gitignore
vim.g.netrw_localrmdir = "rm -r"

if vim.fn.has('gui_running') == 1 then
	vim.cmd[[set guioptions-=T]]
    set.lines = 60
    set.columns = 108
    set.linespace = 0
    set.guifont = "Operator_Mono_Light:h18"
end
