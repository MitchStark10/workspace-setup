return {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npx --yes yarn install",
  init = function()
    -- Auto-close preview when leaving markdown buffer
    vim.g.mkdp_auto_close = 1

    -- Do not auto-open on enter
    vim.g.mkdp_auto_start = 0
  end,
  config = function()
    -- Toggle markdown preview with <leader>mp
    vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<CR>")
  end,
}
