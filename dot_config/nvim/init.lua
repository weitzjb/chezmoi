-- Lazy bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set these globally
vim.g.R_auto_start = 1
vim.g.R_assign = 2

-- Set leader specifically for R before plugin maps load
vim.api.nvim_create_autocmd("FileType", {
  pattern = "r",
  callback = function()
    vim.g.R_leader = "<Space>"
  end,
})

-- Load other config
require("options")
require("keymaps")
require("plugins")

