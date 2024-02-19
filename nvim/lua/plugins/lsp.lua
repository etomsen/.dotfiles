local npm_global_dir = function()
    -- root_dir = require("lspconfig/util").root_pattern("nx.json"),
    -- often ts version does not match the ngserver one. so one need to
    -- install the proper version using npm aliases
    return  "/Users/e.tomsen/.nvm/versions/node/v14.21.3/bin"
end

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
            local function organize_imports()
                local params = {
                    command = "_typescript.organizeImports",
                    arguments = {vim.api.nvim_buf_get_name(0)},
                    title = ""
                }
                vim.lsp.buf.execute_command(params)
            end

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
                root_dir = npm_global_dir,
                cmd = {
                    "typescript-language-server",
                    "--stdio",
                },
                commands = {
                    OrganizeImports = {
                        organize_imports,
                        description = "Organize Imports"
                    }
                }
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
                root_dir = util.root_pattern("nx.json", "lerna.json"),
                on_new_config = function(new_config)
                    new_config.cmd = ngls_cmd
                end,
            })

            -- LSP mappings
            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
            vim.keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
            vim.keymap.set("n", "<Leader>ca", ":lua vim.lsp.buf.code_action()<CR>")
            vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>")
            vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
            vim.keymap.set("n", "<leader>dc", "<cmd>lua vim.diagnostic.hide()<CR>", opts)
            vim.keymap.set('n', '<space>e', ':lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)
            vim.keymap.set('n', '<Leader>oi', ':OrganizeImports<CR>', opts)
        end,
    },
}
