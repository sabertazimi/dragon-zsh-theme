return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "markdownlint-cli2", "markdown-toc" },
      },
    },
  },
}
