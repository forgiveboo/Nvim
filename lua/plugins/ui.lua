---@type LazySpec
return {
  { -- Breadcrumbs
    "Bekaboo/dropbar.nvim",
    lazy = false,
    -- Optional, but required for fuzzy finder support
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  },
  "nvim-tree/nvim-tree.lua",
  opts = require("configs.ui").nvim_tree,
}
