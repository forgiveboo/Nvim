local lspconfig = require "lspconfig"
local mr = require "mason-registry" -- 这行目前没什么用，之后会用上

local nvlsp = require "nvchad.configs.lspconfig"

---@type lspconfig.Config
local default_lspconfig_setup_options = {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

---@type MasonLspconfigSettings
local options = {
  handlers = {
    ---@param server_name string
    function(server_name)
      ---@diagnostic disable-next-line: undefined-field
      lspconfig[server_name].setup(default_lspconfig_setup_options)
    end,

    lua_ls = function()
      dofile(vim.g.base46_cache .. "lsp")
      require("nvchad.lsp").diagnostic_config()

      local settings = {
        Lua = {
          workspace = {
            maxPreload = 1000000,
            preloadFileSize = 10000,
          },
        },
      }

      -- If current working directory is Neovim config directory
      local in_neovim_config_dir = (function()
        local stdpath_config = vim.fn.stdpath "config"
        local config_dirs = type(stdpath_config) == "string" and { stdpath_config } or stdpath_config
        ---@diagnostic disable-next-line: param-type-mismatch
        for _, dir in ipairs(config_dirs) do
          if vim.fn.getcwd():find(dir, 1, true) then
            return true
          end
        end
      end)()

      if in_neovim_config_dir then
        -- Add vim to globals for type hinting
        settings.Lua.diagnostic = settings.Lua.diagnostic or {}
        settings.Lua.diagnostic.globals = settings.Lua.diagnostic.globals or {}
        table.insert(settings.Lua.diagnostic.globals, "vim")

        -- Add all plugins installed with lazy.nvim to `workspace.library` for type hinting
        settings.Lua.workspace.library = vim.list_extend({
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
          "${3rd}/busted/library", -- Unit testing
          "${3rd}/luassert/library", -- Unit testing
          "${3rd}/luv/library", -- libuv bindings (`vim.uv`)
        }, vim.fn.glob(vim.fn.stdpath "data" .. "/lazy/*", true, 1))
      end

      ---@diagnostic disable-next-line: undefined-field
      lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", default_lspconfig_setup_options, {
        settings = settings,
      }))
    end,
  },

  ensure_installed = {
     "lua_ls",
     "html",
     "cssls",
    "pyright",
    "jdtls",
    "clangd"
   },
}

return options
