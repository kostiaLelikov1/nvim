return {
  "zbirenbaum/copilot-cmp",
  dependencies = {
    "zbirenbaum/copilot.lua",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("copilot_cmp").setup()
  end,
}
