return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "html",
            "markdown",
            "json",
            "jsonc",
            "yaml",
            "toml",
            "xml",
            "graphql",
            "astro",
            "svelte",
            "css",
            "less",
            "scss",
          },
        },
        harper_ls = {},
      },
    },
  },
}
