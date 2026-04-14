-- ~/.config/nvim/lua/plugins/dadbod.lua

return {
  {
    "tpope/vim-dadbod",
    lazy = false,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>db", "<cmd>DBUIToggle<CR>",        desc = "DB: Toggle UI" },
      { "<leader>da", "<cmd>DBUIAddConnection<CR>", desc = "DB: Add connection" },
      { "<leader>df", "<cmd>DBUIFindBuffer<CR>",    desc = "DB: Find buffer" },
      { "<leader>dr", "<Plug>(DBUI_ExecuteQuery)",  desc = "DB: Run query",     mode = { "n", "v" } },
    },
    config = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
      vim.g.db_ui_execute_on_save = 0  -- don't auto-run on save

      -- Connections — password read from env var (never committed)
      local picu_pw = os.getenv("PICU_DB_PASSWORD") or ""
      vim.g.dbs = {
        {
          name = "PICU",
          url  = "postgresql://postgres:" .. picu_pw .. "@10.134.177.186:5432/PICU",
        },
      }

    end,
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    lazy = true,
  },
}
