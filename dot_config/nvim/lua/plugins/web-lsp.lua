-- HTML, CSS and SQL language servers. All installed through Mason (they are npm-based, Node is on PATH).
-- JS/TS comes from the lang.typescript extra imported in init.lua.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
        cssls = {},
        sqlls = {},
      },
    },
  },
}
