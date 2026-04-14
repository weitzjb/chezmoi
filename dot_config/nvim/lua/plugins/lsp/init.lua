-- Return a table of plugin specs for lazy.nvim
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {},
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local function on_attach(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
        end
        map("n", "gd",         vim.lsp.buf.definition,  "LSP: Go to definition")
        map("n", "gr",         vim.lsp.buf.references,  "LSP: References")
        map("n", "K",          vim.lsp.buf.hover,        "LSP: Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename,       "LSP: Rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action,  "LSP: Code action")
        map("n", "[d",         vim.diagnostic.goto_prev, "LSP: Prev diagnostic")
        map("n", "]d",         vim.diagnostic.goto_next, "LSP: Next diagnostic")
      end

      -- nvim 0.11+ native API: vim.lsp.config + vim.lsp.enable
      -- Map server name -> executable to check before enabling
      local servers = {
        pyright            = { exe = "pyright",                   opts = {
          settings = { python = { analysis = { typeCheckingMode = "basic", autoImportCompletions = true } } },
        }},
        r_language_server  = { exe = "R",                         opts = {} },
        lua_ls             = { exe = "lua-language-server",       opts = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        }},
        bashls             = { exe = "bash-language-server",      opts = {} },
        marksman           = { exe = "marksman",                  opts = {} },
        jsonls             = { exe = "vscode-json-language-server", opts = {} },
        taplo              = { exe = "taplo",                     opts = {} },
        yamlls             = { exe = "yaml-language-server",      opts = {} },
        sqls               = { exe = "sql-language-server",       opts = {} },
      }

      for server, spec in pairs(servers) do
        if vim.fn.executable(spec.exe) == 1 then
          local opts = spec.opts
          opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
          opts.on_attach    = opts.on_attach or on_attach
          vim.lsp.config(server, opts)
          vim.lsp.enable(server)
        end
      end
    end,
  },
}
