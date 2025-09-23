-- ~/.config/nvim/lua/plugins/colorscheme.lua

return {
    {
        "arcticicestudio/nord-vim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme nord")
        end,
    }
}

