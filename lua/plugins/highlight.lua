---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
  },

  { -- Sticky scroll
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
  },

  { -- Rainbow pair colorization
    "hiphish/rainbow-delimiters.nvim",
    lazy = false,
    config = function()
      require "configs.highlight"
    end,
  },
}
