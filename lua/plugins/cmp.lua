---@type LazySpec
return {
  { -- Override `nvim-cmp` plugin
    "hrsh7th/nvim-cmp",
    lazy = false,
    opts = function()
      return require "configs.cmp"
    end,
  },
}
