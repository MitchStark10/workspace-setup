return {
  "prettier/vim-prettier",
  build = "npm install --frozen-lockfile --production",
  init = function()
    -- Format on save for JS/TS files
    vim.g["prettier#autoformat"] = 1
    vim.g["prettier#autoformat_require_pragma"] = 0
  end,
  config = function()
    -- Format with leader+p
    vim.keymap.set("n", "<leader>p", ":Prettier<CR>")
  end,
}
