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

    local function resolve_biome()
      local local_bin = vim.fn.findfile("node_modules/.bin/biome", ".;")
      if local_bin ~= "" then
        return vim.fn.fnamemodify(local_bin, ":p")
      end
      local global_bin = vim.fn.exepath("biome")
      if global_bin ~= "" then
        return global_bin
      end
      return nil
    end

    vim.keymap.set('n', "<leader>p", function()
      local file = vim.fn.expand("%:p")
      local local_prettier = vim.fn.findfile("node_modules/.bin/prettier", ".;")
      if local_prettier ~= "" then
        local bin = resolve_prettier()
        local output = vim.fn.system(bin .. " --write " .. vim.fn.shellescape(file))
        if vim.v.shell_error ~= 0 then
          vim.notify("Prettier failed:\n" .. output, vim.log.levels.ERROR)
        else
          vim.cmd("edit!")
          vim.notify("Prettier: formatted", vim.log.levels.INFO)
        end
      else
        local biome_bin = resolve_biome()
        if biome_bin then
          local output = vim.fn.system(biome_bin .. " format --write " .. vim.fn.shellescape(file))
          if vim.v.shell_error ~= 0 then
            vim.notify("Biome failed:\n" .. output, vim.log.levels.ERROR)
          else
            vim.cmd("edit!")
            vim.notify("Biome: formatted", vim.log.levels.INFO)
          end
        else
          vim.notify("No prettier or biome found", vim.log.levels.WARN)
        end
      end
    end)
  end,
}
