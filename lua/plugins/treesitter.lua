return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "javascript", "typescript", "tsx", "c_sharp", "python" },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    })

    -- Override Treesitter's [[ and ]] mappings to prioritize LSP diagnostics
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        local opts = { noremap = true, silent = true, buffer = true }
        vim.keymap.set("n", "[[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
        vim.keymap.set("n", "]]", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
      end,
    })

    -- Treesitter context setup
    require("treesitter-context").setup()
  end,
}
