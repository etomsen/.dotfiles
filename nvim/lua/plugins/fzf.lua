return {
  {
    "junegunn/fzf"
  },
  {
    "junegunn/fzf.vim",
    config = function()
      vim.opt.shada = "'20" -- set max history length 
      vim.keymap.set("n", "<leader>fh", "<cmd>History<CR>")
      vim.keymap.set("n", "<leader>fb", "<cmd>Buffers<CR>")
    end
  }
}
