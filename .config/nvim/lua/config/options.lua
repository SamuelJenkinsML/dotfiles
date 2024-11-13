-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Add your general Neovim settings here

return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local servers = { "pyright", "basedpyright", "ruff", "ruff_lsp" }

    -- Loop over servers and configure each
    for _, server in ipairs(servers) do
      opts.servers[server] = opts.servers[server] or {}
      
      -- Add Pyright-specific settings
      if server == "pyright" then
        opts.servers.pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",  -- Set the type checking mode
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        }
      end
    end
  end,
}
