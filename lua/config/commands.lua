local M = {}

function M.setup()
  -- Command to organize and remove unused imports
  vim.api.nvim_create_user_command("OR", function()
    vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports", "source.removeUnusedImports" } },
      apply = true,
    })
  end, {})

  -- Command to open terminal
  vim.api.nvim_create_user_command("T", function()
    vim.cmd("split | terminal")
    vim.cmd("resize 15")
  end, {})
end

return M
