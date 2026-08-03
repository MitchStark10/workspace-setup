return {
  "tpope/vim-commentary",
  config = function()
    -- Map Ctrl+/ to toggle comments in visual mode (Ctrl+/ sends <C-_> in terminals)
    vim.keymap.set("v", "<C-_>", "gc", { remap = true })
  end,
}
