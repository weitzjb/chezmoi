-- ~/.config/nvim/lua/plugins/init.lua

-- Load plugin specs
require("lazy").setup({
    { import = "plugins.colorscheme" },
    { import = "plugins.nvimtree" },
    { import = "plugins.lsp" },
    { import = "plugins.nvimr" },
    { import = "plugins.telescope" },
    { import = "plugins.dadbod" },
    { import = "plugins.toggleterm" },
})

