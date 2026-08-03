--==============================================================================
-- => General
--==============================================================================
-- Set the leader key to space
vim.g.mapleader = " "

-- Map ctrl+j to escape
vim.keymap.set("i", "<C-j>", "<Esc>")
vim.keymap.set("n", "<C-j>", "<Esc>")

vim.keymap.set("n", "<C-i>", "<C-w>")

-- Enable syntax highlighting
vim.cmd("syntax on")

-- Enable filetype detection and plugins
vim.cmd("filetype plugin indent on")

-- Set encoding to UTF-8
vim.o.encoding = "utf-8"

-- Set line numbers
vim.o.number = true

-- Highlight current line
vim.o.cursorline = true

-- Enable mouse support
vim.o.mouse = "a"

-- Case insensitive
vim.o.ignorecase = true

-- Enable intelligent tab detection
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.backspace = "indent,eol,start"

-- Detect indentation from file content
local function detect_indent()
  local sample_lines = math.min(vim.fn.line("$"), 100)
  local spaces = {}

  for lnum = 1, sample_lines do
    local line = vim.fn.getline(lnum)
    local indent = line:match("^%s+")
    if indent and indent:sub(1, 1) == " " then
      local count = #indent
      spaces[count] = (spaces[count] or 0) + 1
    end
  end

  -- Find most common indent size
  local max_count = 0
  local detected = 4
  for size, count in pairs(spaces) do
    if count > max_count then
      max_count = count
      detected = size
    end
  end

  -- Set buffer-local settings
  vim.bo.tabstop = max_count > 0 and detected or 4
end

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if not vim.b.editorconfig then
      detect_indent()
    end
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Enable persistent undo
vim.o.undofile = true
vim.o.undodir = vim.fn.expand("~/.config/nvim/undodir")

-- WSL clipboard support
vim.o.clipboard = "unnamedplus"

--==============================================================================
-- => Package Manager (lazy.nvim)
--==============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

--==============================================================================
-- => Commands
--==============================================================================
require("config.commands").setup()

--==============================================================================
-- => Final Touches
--==============================================================================
-- Create undo directory
vim.fn.mkdir(vim.fn.expand("~/.config/nvim/undodir"), "p")
