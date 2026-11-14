-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.env.PATH = vim.env.HOME .. "/.local/bin:" .. vim.env.PATH

-- Vertical ruler at column 79 as a line-length reminder (PEP 8)
vim.opt.colorcolumn = "79"
