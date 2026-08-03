return {
  "tpope/vim-fugitive",
  dependencies = { "tpope/vim-rhubarb" },
  config = function()
    -- Create GBlame command
    vim.api.nvim_create_user_command("GBlame", "Git blame", {})
  end,
}
