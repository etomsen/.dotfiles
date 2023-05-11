require("harpoon").setup()
require('telescope').load_extension('harpoon')

local k = require("etomsen.utils").keymap
k("n", "<leader>h", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
k("n", "<leader>hm", ":lua require('harpoon.mark').add_file()<CR>")
