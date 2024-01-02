return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "html", "pylsp" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lsp = require("lspconfig")
      local util = require("lspconfig.util")

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      ---- lua_ls
      lsp.lua_ls.setup({})

      ---- html
      lsp.html.setup({
        capabilities = capabilities,
        cmd = {
          "vscode-html-language-server",
          "--stdio",
        },
        filetypes = { "html" },
      })

      -- typescript
      lsp.tsserver.setup({
        capabilities = capabilities,
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        root_dir = require("lspconfig/util").root_pattern("nx.json"),
        cmd = {
          "typescript-language-server",
          "--stdio",
        },
      })

      ---- angularls
      local ngls_cmd = {
        "./node_modules/.bin/ngserver",
        "--stdio",
        "--tsProbeLocations",
        "./node_modules",
        "--ngProbeLocations",
        "./node_modules",
        "--includeCompletionsWithSnippetText",
        "--includeAutomaticOptionalChainCompletions",
        "--logToConsole",
      }

      lsp.angularls.setup({
        cmd = ngls_cmd,
        capabilities = capabilities,
        root_dir = util.root_pattern("nx.json"),
        on_new_config = function(new_config)
          new_config.cmd = ngls_cmd
        end,
      })
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
      vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
      vim.keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
      vim.keymap.set("n", "<Leader>ca", ":lua vim.lsp.buf.code_action()<CR>")
      vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>")
      vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
      vim.keymap.set("n", "<leader>dc", "<cmd>lua vim.diagnostic.hide()<CR>", opts)
      vim.keymap.set('n', '<space>e', ':lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)
    end,
  },
}
