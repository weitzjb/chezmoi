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

