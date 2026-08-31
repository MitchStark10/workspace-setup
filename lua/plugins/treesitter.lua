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

    -- Only fetch grammars that are actually missing. Calling install()
    -- unconditionally re-downloads and recompiles every grammar on every
    -- startup, which competes with LSP attach for no benefit.
    local installed = {}
    for _, lang in ipairs(treesitter.get_installed("parsers")) do
      installed[lang] = true
    end
    local missing = vim.tbl_filter(function(lang)
      return not installed[lang]
    end, languages)
    if #missing > 0 then
      treesitter.install(missing)
    end

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
