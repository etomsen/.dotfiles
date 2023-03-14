local M = {}

function M.setup()
  local actions = require "telescope.actions"
  local telescope = require "telescope"
  telescope.load_extension "fzf"
end

return M
