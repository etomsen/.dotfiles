require('harpoon').setup()
require('telescope').load_extension('harpoon')

local k = require("etomsen.utils").keymap
k("n", "<leader>hh", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
k("n", "<leader>hm", ":lua require('harpoon.mark').toggle_file()<CR>")
