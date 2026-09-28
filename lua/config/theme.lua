local M = {}
local macos_poll_timer
local active_theme

local function detect_system_theme()
  if vim.fn.has("mac") == 1 then
    local result = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
    if vim.v.shell_error == 0 and result:lower():match("dark") then
      return "dark"
    end

    return "light"
  end

  if vim.fn.executable("powershell.exe") == 1 then
    local result = vim.fn.system({
      "powershell.exe",
      "-NoProfile",
      "-Command",
      "(Get-ItemProperty -Path HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize).AppsUseLightTheme",
    })
    if vim.v.shell_error == 0 then
      return result:match("1") and "light" or "dark"
    end
  end

  return nil
end

local function set_theme(theme)
  theme = theme or detect_system_theme() or "dark"
  if active_theme == theme then
    return
  end

  vim.o.background = theme
  vim.cmd("colorscheme " .. (theme == "light" and "tokyonight-day" or "tokyonight-night"))
  active_theme = theme
end

function M.setup()
  set_theme()

  vim.api.nvim_create_user_command("Light", function()
    set_theme("light")
  end, {})

  vim.api.nvim_create_user_command("Dark", function()
    set_theme("dark")
  end, {})

  if vim.fn.has("mac") == 1 then
    macos_poll_timer = (vim.uv or vim.loop).new_timer()
    macos_poll_timer:start(1000, 1000, vim.schedule_wrap(set_theme))

    vim.api.nvim_create_autocmd("VimLeavePre", {
      once = true,
      callback = function()
        macos_poll_timer:stop()
        macos_poll_timer:close()
      end,
    })
  end
end

return M
