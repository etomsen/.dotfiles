return {
  "ThePrimeagen/harpoon", -- recent files
  config = function()
    require("harpoon").setup()
    require("telescope").load_extension("harpoon")

    vim.keymap.set("n", "<leader>hh", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
    vim.keymap.set("n", "<leader>hm", ":lua require('harpoon.mark').toggle_file()<CR>")
  end,
}
