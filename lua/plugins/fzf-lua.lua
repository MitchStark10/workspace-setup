-- Used for the LSP pickers wired up in lua/config/lsp.lua (references,
-- definitions, symbols) so results come with a preview window instead of
-- landing straight in the quickfix list.
-- File/buffer/grep keymaps still come from fzf.vim in lua/plugins/fzf.lua.
return {
  "ibhagwan/fzf-lua",
  opts = {
    winopts = {
      height = 0.85,
      width = 0.85,
      preview = { layout = "vertical", vertical = "down:50%" },
    },
  },
}
