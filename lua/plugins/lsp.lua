return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    {
      "seblj/roslyn.nvim",
      -- pinned: newer commits require Neovim >= 0.12
      commit = "88f837a658df7304ae47fdf251c9560ffbc6bf2b",
    },
  },
  config = function()
    require("config.lsp").setup()
  end,
}
