local M = {}

-- Theme configuration
local function set_theme()
  -- Check OS theme (for WSL, check Windows theme)
  local handle = io.popen(
    'powershell.exe -Command "(Get-ItemProperty -Path HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize).AppsUseLightTheme" 2>/dev/null'
  )
  if handle then
    local result = handle:read("*a")
    handle:close()

    if result:match("1") then
      vim.o.background = "light"
      vim.cmd("colorscheme tokyonight-day")
    else
      vim.o.background = "dark"
      vim.cmd("colorscheme tokyonight-night")
    end
  else
    -- Fallback to dark theme if detection fails
    vim.o.background = "dark"
    vim.cmd("colorscheme tokyonight-night")
  end
end

function M.setup()
  -- Set theme on startup
  set_theme()

  -- Command to manually switch to light mode
  vim.api.nvim_create_user_command("Light", function()
    vim.o.background = "light"
    vim.cmd("colorscheme tokyonight-day")
  end, {})

  -- Command to manually switch to dark mode
  vim.api.nvim_create_user_command("Dark", function()
    vim.o.background = "dark"
    vim.cmd("colorscheme tokyonight-night")
  end, {})
end

return M
