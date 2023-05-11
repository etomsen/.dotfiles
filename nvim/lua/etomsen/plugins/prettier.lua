local prettier = require("prettier")

prettier.setup({
	bin = "prettier",
	filetypes = {
		"html",
		"scss",
		"typescript",
		"yaml",
		"json",
	},
})
