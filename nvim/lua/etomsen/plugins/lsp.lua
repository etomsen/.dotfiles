local lsp = require 'lspconfig'
local vim = vim
local util = require 'lspconfig.util'
local opts = { noremap = true, silent = true }

require('mason').setup()
require('mason-lspconfig').setup {
    ensure_installed = { 'lua_ls', 'html', 'pylsp'},
}

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Mappings.
  buf_set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  buf_set_keymap("n", "<leader>dc", "<cmd>lua vim.diagnostic.hide()<CR>", opts)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())


---- lua_ls
lsp.lua_ls.setup{}

---- html
lsp.html.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
    "vscode-html-language-server",
    "--stdio"
  },
  filetypes = { "html" },
}

-- typescript
lsp.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_dir = require("lspconfig/util").root_pattern("nx.json"),
  cmd = {
    "typescript-language-server",
    "--stdio"
  }
}

---- angularls
-- local ngls_cmd = {
--   "ngserver",
--   "--stdio",
--   "--tsProbeLocations",
--   "",
--   "--ngProbeLocations",
--   "",
--   "--includeCompletionsWithSnippetText",
--   "--includeAutomaticOptionalChainCompletions",
--   "--logToConsole",
-- }

-- angularls fails to match ts and ngserver versions if installed globally, which is correct
-- the only true approach should be to install them localy in the project
-- the lspinstall plugin is doing smth simmilar https://github.com/kabouzeid/nvim-lspinstall
-- npm install @angular/language-server @angular/language-service typescript
---- add project.json if we are in nx project where angular.json is not available on top level
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
  cmd = ngls_cmd ,
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = util.root_pattern('nx.json'), 
  on_new_config = function(new_config) 
    new_config.cmd = ngls_cmd
  end
})

