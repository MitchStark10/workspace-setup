return {
  "preservim/nerdtree",
  init = function()
    -- Show dotfiles (.env, .github, .eslintrc, ...) in the tree by default.
    -- `I` still toggles them off for the current session.
    vim.g.NERDTreeShowHidden = 1

    -- ...but keep .git/ itself out, since it is pure noise in the tree.
    vim.g.NERDTreeIgnore = { "^\\.git$" }
  end,
  config = function()
    -- Open NERDTree with Ctrl+n
    vim.keymap.set("n", "<C-n>", ":NERDTreeToggle<CR>")

    -- Find current file in NERDTree
    vim.keymap.set("n", "fn", ":NERDTreeFind<CR>")
  end,
}
