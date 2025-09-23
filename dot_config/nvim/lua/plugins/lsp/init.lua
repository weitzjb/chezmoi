-- lua/plugins/lsp/init.lua
-- Neovim ≥0.11 prefers vim.lsp.config; fall back to require("lspconfig") on older versions.
local lspcfg = (vim.lsp and vim.lsp.config) or require("lspconfig")

-- Optional: enhanced completion capabilities if you're using nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
  local cmp_caps = require("cmp_nvim_lsp").default_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, cmp_caps)
end)

-- Common on_attach (keymaps etc.)
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
  end
  map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
  map("n", "gr", vim.lsp.buf.references, "LSP: References")
  map("n", "K",  vim.lsp.buf.hover, "LSP: Hover")
  map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
  map("n", "<leader>fd", function() vim.diagnostic.open_float(nil, { border = "rounded" }) end, "LSP: Line diagnostics")
  map("n", "[d", vim.diagnostic.goto_prev, "LSP: Prev diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "LSP: Next diagnostic")
end

-- Helper to setup a server with shared opts
local function setup(server, opts)
  opts = opts or {}
  opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
  opts.on_attach = opts.on_attach or on_attach
  -- New style:
  if vim.lsp and vim.lsp.config then
    vim.lsp.config[server].setup(opts)
  else
    -- Old style fallback:
    require("lspconfig")[server].setup(opts)
  end
end

-- ---- Servers ----------------------------------------------------------------

-- Python
setup("pyright", {
  settings = {
    python = {
      analysis = { typeCheckingMode = "basic", autoImportCompletions = true },
    },
  },
})

-- R
setup("r_language_server")

-- Lua (for Neovim config)
setup("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

-- Bash
setup("bashls")

-- Markdown (optional)
pcall(setup, "marksman")

-- JSON/TOML/YAML (optional; only if you use them)
pcall(setup, "jsonls")
pcall(setup, "taplo")   -- TOML
pcall(setup, "yamlls")

-- You can add more:
-- setup("tsserver")
-- setup("gopls")
-- setup("rust_analyzer")

