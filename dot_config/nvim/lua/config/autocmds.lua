-- Autocmds are automatically loaded on the `VeryLazy` event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. `vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")`

-- Use `harper_ls` instead
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Use `render-markdown.nvim` instead
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Apply dank colors theme on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local dankcolors_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
    local spec = dofile(dankcolors_path)
    if spec and spec[1] and spec[1].config then
      spec[1].config()
    end
  end,
})
