local M = {}

local function on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  local function map(lhs, rhs)
    vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
  end

  local has_fzf, fzf = pcall(require, "fzf-lua")

  -- Navigation. Prefer fzf-lua pickers when available: they give a preview
  -- window instead of dumping straight into the quickfix list.
  map("gD", vim.lsp.buf.declaration)
  map("gd", has_fzf and fzf.lsp_definitions or vim.lsp.buf.definition)
  map("gi", has_fzf and fzf.lsp_implementations or vim.lsp.buf.implementation)
  map("gr", has_fzf and fzf.lsp_references or vim.lsp.buf.references)
  map("<space>D", has_fzf and fzf.lsp_typedefs or vim.lsp.buf.type_definition)
  map("<space>s", has_fzf and fzf.lsp_document_symbols or vim.lsp.buf.document_symbol)
  map("<space>S", has_fzf and fzf.lsp_live_workspace_symbols or vim.lsp.buf.workspace_symbol)

  map("K", vim.lsp.buf.hover)
  map("<C-k>", vim.lsp.buf.signature_help)
  map("<space>rn", vim.lsp.buf.rename)
  map("<space>ca", has_fzf and fzf.lsp_code_actions or vim.lsp.buf.code_action)

  -- Workspace folders
  map("<space>wa", vim.lsp.buf.add_workspace_folder)
  map("<space>wr", vim.lsp.buf.remove_workspace_folder)
  map("<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)

  -- Diagnostics
  map("<space>e", vim.diagnostic.open_float)
  map("[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end)
  map("]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end)
  map("[[", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end)
  map("]]", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end)
  map("<space>q", vim.diagnostic.setloclist)
  map("]a", function()
    if has_fzf then
      fzf.diagnostics_workspace()
    else
      vim.diagnostic.setqflist()
    end
  end)
  map("]e", function()
    if has_fzf then
      fzf.diagnostics_workspace({ severity = vim.diagnostic.severity.ERROR })
    else
      vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
    end
  end)
end

function M.setup()
  -- Mason setup
  require("mason").setup({
    registries = {
      "github:Crashdummyy/mason-registry",
      "github:mason-org/mason-registry",
    },
  })
  -- roslyn.nvim owns the C# client (server name "roslyn"). The Mason package
  -- roslyn-language-server maps to lspconfig's "roslyn_ls", so leaving it in
  -- automatic_enable would start a second C# server and double every
  -- diagnostic. Exclude it here.
  require("mason-lspconfig").setup({
    automatic_enable = { exclude = { "roslyn_ls" } },
  })

  -- Shared defaults for *every* server, including ones mason-lspconfig enables
  -- automatically (eslint, etc). Without this, only servers configured by hand
  -- below would get nvim-cmp's expanded capabilities.
  vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    on_attach = on_attach,
  })

  vim.lsp.enable("ts_ls")

  vim.lsp.config("pyright", {
    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, {
        "pyrightconfig.json",
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "manage.py",
        ".git",
      })
      on_dir(root or vim.fn.getcwd())
    end,
    before_init = function(_, config)
      -- Resolve the interpreter from the project root pyright actually picked,
      -- not from cwd -- cwd is wrong whenever nvim is opened in a subdirectory.
      local root = config.root_dir or vim.fn.getcwd()
      -- Build the candidate list without nil holes: ipairs stops at the first
      -- nil, so a table starting with an unset $VIRTUAL_ENV iterates zero times.
      local candidates = {}
      if vim.env.VIRTUAL_ENV then
        table.insert(candidates, vim.env.VIRTUAL_ENV)
      end
      table.insert(candidates, root .. "/.venv")
      table.insert(candidates, root .. "/venv")

      for _, venv in ipairs(candidates) do
        if vim.fn.executable(venv .. "/bin/python") == 1 then
          config.settings.python.pythonPath = venv .. "/bin/python"
          return
        end
      end
    end,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          -- Required for cross-file find-references to see the whole project.
          diagnosticMode = "workspace",
          -- NOTE: reportMissingImports is deliberately left on. It is the
          -- signal that pyright picked the wrong interpreter, which silently
          -- breaks go-to-reference across modules.
          reportMissingTypeStubs = false,
          reportUnknownMemberType = false,
          reportUnknownArgumentType = false,
          reportUnknownVariableType = false,
          reportUnknownParameterType = false,
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
    settings = {
      -- Roslyn defaults to analysing open files only, so whole-solution
      -- correctness (including whether a using is genuinely unused) is never
      -- computed. If the server gets slow on a large solution, drop
      -- dotnet_analyzer_diagnostics_scope back to "openFiles" and keep the
      -- compiler scope at "fullSolution".
      ["csharp|background_analysis"] = {
        dotnet_analyzer_diagnostics_scope = "fullSolution",
        dotnet_compiler_diagnostics_scope = "fullSolution",
      },
      ["csharp|code_lens"] = {
        dotnet_enable_references_code_lens = true,
      },
      ["csharp|completion"] = {
        dotnet_show_completion_items_from_unimported_namespaces = true,
        dotnet_show_name_completion_suggestions = true,
      },
      ["csharp|symbol_search"] = {
        dotnet_search_reference_assemblies = true,
      },
    },
  })

  require("roslyn").setup({
    -- Find .sln files in child directories too
    broad_search = true,
    -- Stick with the first solution chosen instead of re-guessing per buffer
    lock_target = true,
  })
end

return M
