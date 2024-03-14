return {
  {  "airblade/vim-gitgutter" },
  { "APZelos/blamer.nvim", config = function()
    vim.keymap.set('', '<Leader>bt', ':BlamerToggle<CR>')
  end },
  { "tpope/vim-fugitive", config = function()
        -- Autocommand to close fugitive window when opening smth from it
        -- vim.api.nvim_create_autocmd({ "FileType" }, {
        --     pattern = "*fugitive*",

        --     callback = function()
        --         vim.keymap.set("n", "<CR>", function()
        --             local current_line = vim.api.nvim_get_current_line()
        --             local file_name = string.sub(current_line, 2)
        --             vim.cmd(string.format("tabnew %s", file_name))
        --         end, { silent = true, buffer = 0 })
        --     end
        -- })
    end},
  { "homogulosus/vim-diff"},
}
