return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      vim.keymap.set("n", "<leader>f", "<cmd> Telescope find_files<CR>")
      vim.keymap.set("n", "<leader>g", "<cmd> Telescope live_grep<CR>")
      vim.keymap.set("n", "<leader>b", "<cmd> Telescope buffers<CR>")
    end
  },
  -- {
  --   "nvim-telescope/telescope-fzf-native.nvim",
  --   build = 'make',
  --   dependencies = {
  --     "nvim-lua/plenary.nvim"
  --   },
  --   config = function()
  --     require("telescope").setup({
  --       extensions = {
  --         fzf = {
  --           fuzzy = true
  --         }
  --       }
  --     })
  --     require("telescope").load_extension("fzf")
  --   end
  -- },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = require("telescope.themes").get_dropdown({}),
        },
      })
      require("telescope").load_extension("ui-select")
    end
  }
}
