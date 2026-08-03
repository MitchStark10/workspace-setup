return {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      python = { "flake8" },
    }

    -- Run linter on save and when entering buffer
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
      pattern = "*.py",
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
