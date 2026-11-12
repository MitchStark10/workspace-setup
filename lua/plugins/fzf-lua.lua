-- Used for LSP navigation and file pickers so results share a spacious,
-- bottom-preview layout.
return {
  "ibhagwan/fzf-lua",
  opts = {
    winopts = {
      height = 0.85,
      width = 0.85,
      preview = { layout = "vertical", vertical = "down:50%" },
    },
    files = {
      cmd = vim.fn.has("win32") == 1
          and "git rev-parse --is-inside-work-tree >nul 2>&1 && git ls-files --cached --others --exclude-standard || dir /s /b /a-d"
        or [[if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then git ls-files --cached --others --exclude-standard; else find . -type f ! -path '*/.git/*' ! -path '*/.jj/*' ! -path '*/node_modules/*'; fi]],
    },
  },
  config = function(_, opts)
    local fzf = require("fzf-lua")
    fzf.setup(opts)

    vim.keymap.set("n", "<C-p>", fzf.files, { desc = "Find files" })
  end,
}
