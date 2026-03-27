return {
  "MunifTanjim/prettier.nvim",
  config = function()
    local prettier = require("prettier")

    prettier.setup({
      bin = "prettier",
      filetypes = {
        "css",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "scss",
        "typescript",
        "typescriptreact",
        "yaml",
      },
    })

    vim.keymap.set('n', "<leader>p", "<cmd> Prettier<CR>")
  end,
}
