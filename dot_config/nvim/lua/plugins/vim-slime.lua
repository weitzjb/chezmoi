return {
  "jpalardy/vim-slime",
  init = function()
    vim.g.slime_target = "neovim"
    vim.g.slime_dont_ask_default = 1
    vim.g.slime_paste_file = vim.fn.expand("$HOME/.slime_paste")
  end,
}
