-- Return a table of plugin specs for lazy.nvim
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",         -- optional, for capabilities
      -- "williamboman/mason.nvim",    -- uncomment if you use mason
      -- "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Ensure lspconfig is loaded (populates vim.lsp.config on ≥0.11)
      local has_lspconfig, lspconfig_mod = pcall(require, "lspconfig")
      local new_api = (vim.lsp and vim.lsp.config) or nil

      -- helper to get a server setup fn from new or old API
      local function get_setup(server)
        if new_api and new_api[server] and new_api[server].setup then
          return new_api[server].setup
        end
        if has_lspconfig and lspconfig_mod[server] and lspconfig_mod[server].setup then
          return lspconfig_mod[server].setup
        end
        return nil
      end

      -- capabilities (optional: nvim-cmp)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      pcall(function()
        local cmp_caps = require("cmp_nvim_lsp").default_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_caps)
      end)

      -- on_attach with a few keymaps
      local function on_attach(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
        end
        map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
        map("n", "gr", vim.lsp.buf.references, "LSP: References")
        map("n", "K",  vim.lsp.buf.hover, "LSP: Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
        map("n", "[d", vim.diagnostic.goto_prev, "LSP: Prev diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "LSP: Next diagnostic")
      end

      local function setup(server, opts)
        local do_setup = get_setup(server)
        if not do_setup then
          vim.schedule(function()
            vim.notify(("LSP server '%s' not found (plugin not loaded or wrong name)"):format(server),
              vim.log.levels.WARN)
          end)
          return
        end
        opts = opts or {}
        opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
        opts.on_attach = opts.on_attach or on_attach
        do_setup(opts)
      end

      -- Servers
      setup("pyright", {
        settings = {
          python = { analysis = { typeCheckingMode = "basic", autoImportCompletions = true } },
        },
      })

      setup("r_language_server")
      setup("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
      setup("bashls")
      pcall(setup, "marksman")
      pcall(setup, "jsonls")
      pcall(setup, "taplo")
      pcall(setup, "yamlls")
    end,
  },
}

