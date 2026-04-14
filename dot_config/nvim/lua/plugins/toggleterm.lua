-- ~/.config/nvim/lua/plugins/toggleterm.lua

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<C-\>]],
        direction = "vertical",
        shade_terminals = true,
        persist_mode = true,
      })

      -- Dedicated terminal for Claude Code (terminal 2)
      local Terminal = require("toggleterm.terminal").Terminal
      local claude = Terminal:new({
        cmd = "claude",
        count = 2,
        direction = "vertical",
        hidden = true,
      })

      vim.keymap.set("n", [[<C-\>]], "<cmd>ToggleTerm<CR>",  { desc = "Toggle terminal" })
      vim.keymap.set("n", "<leader>cc", function() claude:toggle() end, { desc = "Toggle Claude Code" })

      -- Easy escape from terminal mode
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
      vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Move left from terminal" })
      vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Move right from terminal" })
    end,
  },
}
