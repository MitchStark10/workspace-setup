return {
  "junegunn/fzf",
  build = function()
    vim.fn["fzf#install"]()
  end,
  dependencies = { "junegunn/fzf.vim" },
  init = function()
    -- Enable search history
    vim.g.fzf_history_dir = "~/.local/share/fzf-history"

    -- :Files shells out to $FZF_DEFAULT_COMMAND, and the stock fzf default
    -- skips dotfiles -- so .env and .github/* never showed up. Drive it with a
    -- searcher that can list them: dotfiles included, .gitignore still
    -- respected, .git/ still out. Left unset if neither tool is installed, so
    -- :Files degrades to fzf's default rather than breaking outright.
    if vim.fn.executable("rg") == 1 then
      vim.env.FZF_DEFAULT_COMMAND = [[rg --files --hidden --glob "!.git/*"]]
    elseif vim.fn.executable("ag") == 1 then
      vim.env.FZF_DEFAULT_COMMAND = [[ag --hidden --ignore .git -g ""]]
    end
  end,
  config = function()
    -- Find files with Ctrl+p
    vim.keymap.set("n", "<C-p>", ":Files<CR>")

    -- fzf.vim's own :Ag passes no options through, and ag skips dotfiles
    -- unless asked. Redefine it with --hidden so <C-f> matches :Files.
    vim.api.nvim_create_user_command("Ag", function(opts)
      vim.fn["fzf#vim#ag"](
        opts.args,
        "--hidden",
        vim.fn["fzf#vim#with_preview"](),
        opts.bang and 1 or 0
      )
    end, { bang = true, nargs = "*" })

    -- Show recent buffers with Ctrl+b
    vim.keymap.set("n", "<C-b>", ":Buffers<CR>")

    vim.keymap.set("n", "<C-f>", ":Ag<CR>")
  end,
}
