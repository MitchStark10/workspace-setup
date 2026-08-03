local M = {}

local function on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<space>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    opts
  )
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "[[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "]]", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "]a", "<cmd>lua vim.diagnostic.setqflist()<CR>", opts)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "]e",
    "<cmd>lua vim.diagnostic.setqflist({severity = vim.diagnostic.severity.ERROR})<CR>",
    opts
  )
end

function M.setup()
  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- Mason setup
  require("mason").setup({
    registries = {
      "github:Crashdummyy/mason-registry",
      "github:mason-org/mason-registry",
    },
  })
  require("mason-lspconfig").setup()

  vim.lsp.config("ts_ls", {
    on_attach = on_attach,
  })
  vim.lsp.enable("ts_ls")

  vim.lsp.config("pyright", {
    on_attach = on_attach,
    root_dir = function(fname)
      local util = require("lspconfig.util")
      -- Look for common Python project markers
      local root = util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt", "manage.py")(
        fname
      )
      return root or vim.fn.getcwd()
    end,
    before_init = function(_, config)
      -- Try to detect virtual environment
      local venv_paths = {
        vim.fn.getcwd() .. "/venv",
        vim.fn.getcwd() .. "/.venv",
        vim.env.VIRTUAL_ENV,
      }

      for _, venv in ipairs(venv_paths) do
        if venv and vim.fn.isdirectory(venv) == 1 then
          config.settings.python.pythonPath = venv .. "/bin/python"
          break
        end
      end
    end,
    settings = {
      python = {
        pythonPath = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or nil,
        analysis = {
          typeCheckingMode = "basic", -- Use basic instead of strict
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
          reportMissingImports = false,
          reportMissingTypeStubs = false, -- Suppress missing type stubs errors
          reportUnknownMemberType = false,
          reportUnknownArgumentType = false,
          reportUnknownVariableType = false,
          reportUnknownParameterType = false,
          reportGeneralTypeIssues = false, -- Suppress general type issues
          diagnosticSeverityOverrides = {
            reportOptionalMemberAccess = "none",
            reportOptionalSubscript = "none",
            reportOptionalCall = "none",
          },
        },
      },
    },
  })
  vim.lsp.enable("pyright")

  vim.lsp.config("roslyn", {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  require("roslyn").setup({})
end

return M
