return {
    "vimwiki/vimwiki",
    init = function()
        vim.g.vimwiki_list = {
            { path = "~/Documents/wiki", syntax = "markdown", ext = ".md" },
            { path = "~/prj/tinkoff/notes", syntax = "markdown", ext = ".md" }
        }
        vim.keymap.set("n", "<leader>w<leader>n", "<cmd>VimwikiDiaryNextDay<CR>")
        vim.keymap.set("n", "<leader>w<leader>p", "<cmd>VimwikiDiaryPrevDay<CR>")
    end,
}
