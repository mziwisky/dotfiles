-- Enable hybrid line numbers by default
vim.opt.number = true
vim.opt.relativenumber = true

-- Create an autocommand group for line number toggling
local numbertoggle = vim.api.nvim_create_augroup("NumberToggle", { clear = true })

-- Switch to absolute numbers when entering insert mode or losing focus
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = numbertoggle,
  callback = function()
    if vim.opt.number:get() then
      vim.opt.relativenumber = false
    end
  end,
})

-- Switch back to relative numbers when entering normal mode or gaining focus
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = numbertoggle,
  callback = function()
    if vim.opt.number:get() and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

-- I'm not hip to folds yet, so don't ever auto-fold anything
vim.opt.foldlevelstart = 99

-- 100 columns feels about right most of the time
vim.opt.textwidth = 100

-- When scrolling keep the cursor 5 lines away from the bottom/top
vim.opt.scrolloff = 5

-- More natural split opening
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Swapfiles are for wusses
vim.opt.swapfile = false

-- Use spaces, not tabs
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
-- Actual tabs render as 4 spaces
vim.opt.tabstop = 4
-- Show whitespace chars
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ", -- tabs
  trail = "·", -- trailing spaces
  extends = "›", -- truncated on right (with nowrap)
  precedes = "‹", -- truncated on left (with nowrap)
  nbsp = "␣",
}

-- Searches ignore case unless I use a capital letter
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 0.25s (not 4s) to fire CursorHold autocommands. I have one to do LSP-aware highlighting of
-- matching references to the symbol under my cursor.
vim.opt.updatetime = 250
