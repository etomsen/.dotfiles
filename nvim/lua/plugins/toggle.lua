return {
  "etomsen.toggle",
  dir = "../etomsen/toggle",
  config = function()
    require("etomsen.toggle").setup({
            {filetype = "typescript", from = ".ts", to = ".spec.ts", name = "spec.ts <= ts"},
            {filetype = "typescript", from = ".spec.ts", to = ".ts", name = "spec.ts => ts"},
            {filetype = "typescript", from = ".ts", to = ".html", name = "html <=> ts"},
            {filetype = "typescript", from = ".ts", to = ".scss", name = "scss <=> ts"}
        });
    vim.keymap.set('', '<Leader>ft', ':ToggleFile<CR>')
    vim.keymap.set('', '<Leader>as', ':ToggleFileTo .spec.ts<CR>')
    vim.keymap.set('', '<Leader>aa', ':ToggleFileTo .ts<CR>')
  end
}
