require("toggleterm").setup({
    direction = "float",
    close_on_exit = false,
    on_open = function(term)
		vim.cmd("startinsert!")
	end
})


vim.keymap.set("n", "<Leader>t", ":ToggleTerm<CR>")
