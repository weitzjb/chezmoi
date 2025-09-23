-- ~/.config/nvim/lua/plugins/nvimtree.lua

return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional: for file icons
    },
    config = function()
      local nvim_tree = require("nvim-tree")

      nvim_tree.setup({
        view = {
          width = 35,
          side = "left",
        },
        renderer = {
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
          ignore = false,
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          api.config.mappings.default_on_attach(bufnr)
          -- You can add custom per-buffer keymaps here if needed
        end,
      })

      -- 🔁 Smart toggle: open if closed, focus if already open
      vim.keymap.set("n", "<leader>e", function()
        local api = require("nvim-tree.api")
        if api.tree.is_visible() then
          api.tree.focus()
        else
          api.tree.open()
        end
      end, { desc = "Toggle or focus nvim-tree" })

      -- 📁 Auto-open nvim-tree if started with a directory
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          local directory = vim.fn.isdirectory(data.file) == 1
          if directory then
            vim.cmd.cd(data.file)
            require("nvim-tree.api").tree.open()
          end
        end,
      })
    end,
  }
}

