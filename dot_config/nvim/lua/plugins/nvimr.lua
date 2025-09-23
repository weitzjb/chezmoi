-- ~/.config/nvim/lua/plugins/nvimr.lua

return {
    {
        "jalvesaq/Nvim-R",
        ft = "r",
        config = function()
            vim.g.R_auto_start = 1
            vim.g.R_assign = 2
            vim.g.R_leader = "<Space>"

            -- Keymap to jump to the Nvimr-R-use help page
            vim.keymap.set("n", "<leader>ru", "<cmd>help Nvim-R-use<CR>", {
                desc = "Help: Nvim-R usage guide"
            })
        end,
    }
}

