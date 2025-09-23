-- lua/keymaps.lua

-- Remap 'fd' to escape insert mode quickly
vim.keymap.set("i", "fd", "<Esc>", { noremap = true })


-- Easier window navigation (Ctrl + h/j/k/l)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Buffer navigation
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Close current buffer
vim.keymap.set("n", "<leader>q", ":bd<CR>", { desc = "Close buffer" })

-- Quickly save
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- Quit all
vim.keymap.set("n", "<leader>Q", ":qa<CR>", { desc = "Quit all" })

