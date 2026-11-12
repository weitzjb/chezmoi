-- Quarto (.qmd): quarto-nvim gives filetype handling, preview and chunk-aware LSP via otter.nvim,
-- which proxies python/r/bash language servers into code chunks.
-- Keys use <localleader> (default "\") so they don't clash with LazyVim's <leader>q (sessions) group.
return {
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto" },
    opts = {
      lspFeatures = {
        enabled = true,
        chunks = "curly",
        languages = { "python", "r", "bash", "html" },
        diagnostics = { enabled = true, triggers = { "BufWritePost" } },
        completion = { enabled = true },
      },
      codeRunner = { enabled = false }, -- vim-slime already handles sending code
    },
    keys = {
      { "<localleader>qp", "<cmd>QuartoPreview<cr>", desc = "Quarto preview", ft = "quarto" },
      { "<localleader>qq", "<cmd>QuartoClosePreview<cr>", desc = "Quarto close preview", ft = "quarto" },
      { "<localleader>qa", "<cmd>QuartoActivate<cr>", desc = "Quarto activate LSP in chunks", ft = "quarto" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline", "python", "r", "yaml", "bash", "html" })
    end,
  },
}
