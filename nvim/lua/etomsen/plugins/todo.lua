local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local ok, todo = pcall(require, "todo-comments")
if not ok then return end

todo.setup({
  signs = true,
	highlight = {
		keyword = "bg",
	},
	keywords = {
		TODO = { icon = "?", color = "info", alt = { "// TODO:" } },
		FIX = { icon = "☠", color = "error", alt = { "// FIXME:", "// BUG:", "// FIXIT:", "// ISSUE:" } },
		WARN = { icon = "⚠", color = "warning", alt = { "// WARNING:", "// XXX:" } },
		PERF = { icon = "⏲ ", alt = { "// OPTIM", "// PERFORMANCE", "// OPTIMIZE"}  },
		NOTE = { icon = "✎", color = "hint", alt = { "// INFO"} },
		TEST = { icon = "✓", color = "test", alt = { "// TESTING", "// PASSED", "// FAILED"} },
	},
  merge_keywords = false,
	search = {
		command = "rg",
		args = {
			"--no-heading",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			"--trim",
			"--glob=!vendor",
			"--glob=!.git",
			"--glob=!node_modules",
		},
	},
})
keymap("n", "<leader>td", "<cmd>TodoTelescope<CR>", opts)
