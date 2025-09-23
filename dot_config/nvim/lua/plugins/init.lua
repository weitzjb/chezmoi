-- ~/.config/nvim/lua/plugins/init.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- Load plugin specs
require("lazy").setup({
    { import = "plugins.colorscheme" },
    { import = "plugins.nvimtree" },
    { import = "plugins.lsp" },
    { import = "plugins.nvimr" },
})

