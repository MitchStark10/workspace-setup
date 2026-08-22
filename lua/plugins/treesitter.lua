return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
  },
  config = function()
    local treesitter = require("nvim-treesitter")
    local languages = { "javascript", "typescript", "tsx", "c_sharp", "python", "markdown", "markdown_inline" }

    treesitter.setup()
    treesitter.install(languages)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "javascript", "typescript", "typescriptreact", "cs", "python", "markdown" },
      callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
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
