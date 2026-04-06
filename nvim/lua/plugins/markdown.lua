return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "markdown" },
  opts = {
    heading = {
      enabled = true,
      sign = false,
      icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
    },
    code = {
      enabled = true,
      sign = false,
      style = "full",
    },
    bullet = {
      enabled = true,
    },
    checkbox = {
      enabled = true,
    },
    pipe_table = {
      enabled = true,
      style = "full",
    },
  },
}
