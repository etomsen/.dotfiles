return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
  config = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      return
    end

    configs.setup({
      auto_install = true,
      indent = {
        enable = true,
        disable = {},
      },
      -- One of "all", "maintained" (parsers with maintainers), or a list of languages
      ensure_installed = {
        "bash",
        "dockerfile",
        "javascript",
        "json",
        "lua",
        "typescript",
        "yaml",
        "python",
        "sql",
        "angular",
      },

      sync_install = true,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",

            ["ac"] = "@conditional.outer",
            ["ic"] = "@conditional.inner",

            ["ap"] = "@parameter.outer",
            ["ip"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
          },
        },
      },
    })

    local vim = vim
    local o = vim.o

    o.foldmethod = "expr"
    o.foldexpr = "nvim_treesitter#foldexpr()"
  end,
}
