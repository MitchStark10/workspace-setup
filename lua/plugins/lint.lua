return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      python = { "flake8" },
    }

    -- Prefer the project venv's flake8 over whatever is on PATH. A global
    -- flake8 runs on the wrong interpreter and reports junk for projects
    -- pinned to a different Python.
    local flake8 = lint.linters.flake8
    local base_cmd = flake8.cmd
    flake8.cmd = function()
      local root = vim.fs.root(0, { ".flake8", "setup.cfg", "tox.ini", "pyproject.toml", ".git" })
      local candidates = {}
      if vim.env.VIRTUAL_ENV then
        table.insert(candidates, vim.env.VIRTUAL_ENV)
      end
      if root then
        table.insert(candidates, root .. "/.venv")
        table.insert(candidates, root .. "/venv")
      end

      for _, venv in ipairs(candidates) do
        if vim.fn.executable(venv .. "/bin/flake8") == 1 then
          return venv .. "/bin/flake8"
        end
      end
      return base_cmd
    end

    -- Lint on save only. The previous BufEnter/InsertLeave triggers spawned a
    -- flake8 process on nearly every cursor movement between buffers.
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "*.py",
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
