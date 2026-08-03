return {
  "preservim/nerdtree",
  config = function()
    -- Open NERDTree with Ctrl+n
    vim.keymap.set("n", "<C-n>", ":NERDTreeToggle<CR>")

    -- Find current file in NERDTree
    vim.keymap.set("n", "fn", ":NERDTreeFind<CR>")
  end,
}
