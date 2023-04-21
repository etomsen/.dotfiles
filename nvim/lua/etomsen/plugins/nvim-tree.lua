local k = require("etomsen.utils").keymap


require'nvim-tree'.setup{
	actions = {
      open_file = {
      	quit_on_open = true,
      },
	},
  renderer = {
    full_name = true,
    group_empty = true,
    special_files = {},
    symlink_destination = false,
    indent_markers = {
      enable = true,
    },
    icons = {
      git_placement = "signcolumn",
      show = {
        file = false,
        folder = false,
        folder_arrow = false,
        git = true,
      },
    },
  },
	view = {
		float = {
			enable = true,
			open_win_config = {
        relative = "editor",
        border = "rounded",
        width = 90,
        height = 130,
        row = 100,
        col = 200,
			},
		},
	},
}

k("n", "<leader>b", ":NvimTreeToggle<CR>")
k("n", "<leader>e", ":NvimTreeFindFile<CR>")
