local vim = vim

function _G.OpenDailyNote()
  local path = vim.env.MYVIMRC
  local command = path:match("(.*/)") .. "lua/etomsen/daily-note/note.sh --directory " .. os.getenv("HOME")
  local Terminal = require("toggleterm.terminal").Terminal
  local run = Terminal:new({
    cmd = command,
    hidden = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    on_open = function(term)
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Leader>n", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
  })

	run:toggle()
end

vim.api.nvim_create_user_command('DailyNote', OpenDailyNote, { desc = "Open daily note *.md in floaterm"})
vim.keymap.set('', '<Leader>n', ':DailyNote<CR>')
