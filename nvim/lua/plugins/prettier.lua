return {
  "MunifTanjim/prettier.nvim",
  dependencies = { "nvimtools/none-ls.nvim" },
  config = function()
    local prettier = require("prettier")

    local function resolve_prettier()
      local local_bin = vim.fn.findfile("node_modules/.bin/prettier", ".;")
      if local_bin ~= "" then
        return vim.fn.fnamemodify(local_bin, ":p")
      end
      local global_bin = vim.fn.exepath("prettier")
      if global_bin ~= "" then
        return global_bin
      end
      return "prettier"
    end

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

    vim.keymap.set('n', "<leader>p", function()
      local bin = resolve_prettier()
      local file = vim.fn.expand("%:p")
      local output = vim.fn.system(bin .. " --write " .. vim.fn.shellescape(file))
      if vim.v.shell_error ~= 0 then
        vim.notify("Prettier failed:\n" .. output, vim.log.levels.ERROR)
      else
        vim.cmd("edit!")
        vim.notify("Prettier: formatted", vim.log.levels.INFO)
      end
    end)
  end,
}
