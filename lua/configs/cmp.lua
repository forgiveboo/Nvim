---@module "cmp.init"
---@diagnostic disable-next-line: assign-type-mismatch
local cmp = require "cmp"
local copilot_suggestion = require "copilot.suggestion"
local luasnip = require "luasnip"

---@type cmp.ConfigSchema
local options = require "nvchad.configs.cmp"

-- Use suggestions from GitHub Copilot if available
options.mapping["<Tab>"] = cmp.mapping(function(fallback)
  if cmp.visible() then
    -- Dismiss Copilot suggestion if it's visible
    if copilot_suggestion.is_visible() then
      copilot_suggestion.dismiss()
    end
    cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
    -- 提示: 这里使用了 `cmp.SelectBehaviro.Insert`，也就是说当你选择了 nvim-cmp 的补全项之后会自动插入文本
    -- 如果你不喜欢，可以把它改成 cmp.SelectBehavior.Select，这样就和 VSCode 的默认行为一样了
    -- 顺便如果你改成了 cmp.SelectBehavior.Select，上边的 Dismiss Copilot 的代码也可以删掉了
  elseif copilot_suggestion.is_visible() then
    copilot_suggestion.accept()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    fallback()
  end
end, { "i", "s" })

return options
