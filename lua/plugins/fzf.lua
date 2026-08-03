return {
  "junegunn/fzf",
  build = function()
    vim.fn["fzf#install"]()
  end,
  dependencies = { "junegunn/fzf.vim" },
  init = function()
    -- Enable search history
    vim.g.fzf_history_dir = "~/.local/share/fzf-history"
  end,
  config = function()
    -- Find files with Ctrl+p
    vim.keymap.set("n", "<C-p>", ":Files<CR>")

    -- Show recent buffers with Ctrl+b
    vim.keymap.set("n", "<C-b>", ":Buffers<CR>")

    vim.keymap.set("n", "<C-f>", ":Ag<CR>")
  end,
}
