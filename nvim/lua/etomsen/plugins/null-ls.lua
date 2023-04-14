local plugin = require("null-ls")
plugin.setup({
  sources = {
    plugin.builtins.formatting.prettier,
    plugin.builtins.formatting.stylua,
    plugin.builtins.diagnostics.eslint,
    plugin.builtins.completion.spell,
  },
})

vim.cmd('map <Leader>ln :lua vim.lsp.buf.formatting_sync(nil, 10000)<CR>')
