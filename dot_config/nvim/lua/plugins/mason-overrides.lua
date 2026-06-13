-- ruff and sqlfluff fail via mason on Python 3.14 (ensurepip broken).
-- Install via Homebrew instead: brew install ruff sqlfluff
-- Setting mason=false tells LazyVim not to auto-install these via mason;
-- they will still work as LSP/formatters since they're on PATH via brew.
local brew_managed = { ruff = true, sqlfluff = true }

local function filter(t)
  return vim.tbl_filter(function(s) return not brew_managed[s] end, t or {})
end

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = filter(opts.ensure_installed)
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = filter(opts.ensure_installed)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = { mason = false },
      },
    },
  },
}
