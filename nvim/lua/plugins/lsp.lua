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
                ensure_installed = { "lua_ls", "html", "pylsp", "ts_ls", "marksman" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- Apply cmp_nvim_lsp capabilities to all servers
            local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            ---- lua_ls
            vim.lsp.config("lua_ls", {})

            ---- html
            vim.lsp.config("html", {
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

            vim.lsp.config("ts_ls", {})

            -- Register OrganizeImports user command
            vim.api.nvim_create_user_command("OrganizeImports", organize_imports, { desc = "Organize Imports" })

            -- Disable angularls (ngserver not installed)
            vim.lsp.enable("angularls", false)

            -- markdown
            vim.lsp.config("marksman", {})

            -- Enable all configured servers
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("html")
            vim.lsp.enable("ts_ls")
            vim.lsp.enable("marksman")

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
