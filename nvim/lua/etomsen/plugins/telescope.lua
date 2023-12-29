require("telescope").setup({
  extensions = {
    ["ui-select"] = require("telescope.themes").get_dropdown({}),
  },
})
require("telescope").load_extension("ui-select")
require("telescope").load_extension("fzf")

vim.keymap.set("n", "<leader>f", "<cmd> Telescope find_files<CR>")
vim.keymap.set("n", "<leader>g", "<cmd> Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>b", "<cmd> Telescope buffers<CR>")
