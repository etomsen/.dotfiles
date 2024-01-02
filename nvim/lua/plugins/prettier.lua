return {
  "MunifTanjim/prettier.nvim",
  config = function()
    local prettier = require("prettier")

    prettier.setup({
      bin = "prettier",
      filetypes = {
        "html",
        "scss",
        "typescript",
        "yaml",
        "json",
      },
    })
  end,
}
