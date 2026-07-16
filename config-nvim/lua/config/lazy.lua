-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- LSP languages to install

-- Enable hybrid line numbers by default
vim.opt.number = true
vim.opt.relativenumber = true

-- I'm not hip to folds yet, so don't ever auto-fold anything
vim.opt.foldlevelstart = 99

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


-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" }
  },
  -- Configure any other settings here. See the documentation for more details.
  checker = {
    enabled = true, -- automatically check for plugin updates
    notify = false, -- don't do the annoying notification (i have a statusline item)
    frequency = 259200, -- check once every 3 days
  },
})

vim.cmd.colorscheme "catppuccin-mocha"

local function plugin_updates_status()
  local status = require("lazy.status")
  local function get_str()
    return status.updates() .. " Plugin update(s) available! (run :Lazy)"
  end
  return {
    get_str,
    color = { fg = "#ff9e64" },
    cond = status.has_updates
  }
end

require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = true,
    icons_enabled = true,
    component_separators = "",
    section_separators = "",
  },

  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {
      {
        "filename",
        path = 1, -- relative path
      },
    },
    lualine_x = {
      plugin_updates_status(),
      "encoding",
      "fileformat",
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        path = 1,
      },
    },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
})

require('rgflow').setup({
  -- Set the default rip grep flags and options for when running a search via
  -- RgFlow. Once changed via the UI, the previous search flags are used for 
  -- each subsequent search (until Neovim restarts).
  cmd_flags = "--smart-case --fixed-strings --ignore --max-columns 200",

  -- Mappings to trigger RgFlow functions
  default_trigger_mappings = true,
  -- These mappings are only active when the RgFlow UI (panel) is open
  default_ui_mappings = true,
  -- QuickFix window only mapping
  default_quickfix_mappings = true,
})

-- write, quit
vim.keymap.set({'n','v'}, '<Leader>w', '<cmd>w<CR>')
vim.keymap.set({'n','v'}, "<Leader>q", "<cmd>q<CR>")

-- quick splits
vim.keymap.set({'n','v'}, "<Leader>s", "<cmd>sp<CR>")
vim.keymap.set({'n','v'}, '<Leader>v', '<cmd>vsp<CR>')

-- better movement
vim.keymap.set('n', 'j', [[(v:count > 1 ? 'm`' . v:count : v:count == 0 ? 'g' : '') . 'j']], { expr = true, desc = 'down' })
vim.keymap.set('n', 'k', [[(v:count > 1 ? 'm`' . v:count : v:count == 0 ? 'g' : '') . 'k']], { expr = true, desc = 'up' })
vim.keymap.set('x', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'down' })
vim.keymap.set('x', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'up' })


-- Force built-in '*' to be case-sensitive by appending \C
vim.keymap.set('n', '*', function()
  local word = vim.fn.expand('<cword>')
  vim.fn.setreg('/', '\\<' .. word .. '\\>\\C')
  vim.opt.hlsearch = true
  -- Move to the next match manually
  local success, _ = pcall(vim.cmd, 'normal! n')
  if not success then
    print("Pattern not found: " .. word)
  end
end, { desc = "Case-sensitive word search forward" })

-- Force built-in '#' to be case-sensitive by appending \C
vim.keymap.set('n', '#', function()
  local word = vim.fn.expand('<cword>')
  vim.fn.setreg('/', '\\<' .. word .. '\\>\\C')
  vim.opt.hlsearch = true
  -- Move to the previous match manually
  local success, _ = pcall(vim.cmd, 'normal! N')
  if not success then
    print("Pattern not found: " .. word)
  end
end, { desc = "Case-sensitive word search backward" })


local tele = require('telescope.builtin')
-- my muscle memory
vim.keymap.set('n', '<Leader>o', tele.find_files, { desc = 'Find file' })
vim.keymap.set('n', '<Leader>m', tele.oldfiles, { desc = 'Find recent file'} )

vim.keymap.set('n', '<Leader>g', tele.grep_string, { desc = 'Grep word under cursor' })
-- -- haven't decided yet if i want Space-g to be case sensitive... if i do, this is how:
-- vim.keymap.set('n', '<Leader>g', function()
--   tele.grep_string({additional_args = { '--case-sensitive' } })
-- end, { desc = 'Grep word under cursor (Case sensitive)' })
-- -- or, if i want smartcase, this is how:
-- local tele = require('telescope.builtin')
-- vim.keymap.set('n', '<Leader>g', function()
--   tele.grep_string({ case_mode = "respect_ignorecase" })
-- end, { desc = 'Grep word under cursor (Smartcase)' })

vim.keymap.set('v', '<Leader>g', tele.grep_string, { desc = 'Grep current selection' })

-- telescope's recommendations
vim.keymap.set('n', '<Leader>ff', tele.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<Leader>fg', tele.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<Leader>fb', tele.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<Leader>fh', tele.help_tags, { desc = 'Telescope help tags' })


local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- highlight my search term after i move live-grep results to quickfix
local send_to_qf_and_highlight = function(prompt_bufnr)
  -- 1. Get the current text typed into the Telescope prompt
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local text = current_picker:_get_prompt()

  -- 2. Send the text to Neovim's search register and turn on highlighting
  vim.fn.setreg("/", text)
  vim.opt.hlsearch = true

  -- 3. Run the default smart send to quickfix action and open it
  actions.smart_send_to_qflist(prompt_bufnr)
  actions.open_qflist()
end

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-q>"] = send_to_qf_and_highlight,
        -- more natural preview scrolling
        ["<C-h>"] = actions.preview_scrolling_left,
        ["<C-l>"] = actions.preview_scrolling_right,
        -- results selection
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        -- open in new splits/tabs
        ["<C-s>"] = actions.file_split,
        ["<C-v>"] = actions.file_vsplit,
        ["<C-t>"] = actions.file_tab,
      },
      n = {
        ["<C-q>"] = send_to_qf_and_highlight,
        -- more natural preview scrolling
        ["<C-h>"] = actions.preview_scrolling_left,
        ["<C-l>"] = actions.preview_scrolling_right,
        -- results selection
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        -- open in new splits/tabs
        ["<C-s>"] = actions.file_split,
        ["<C-v>"] = actions.file_vsplit,
        ["<C-t>"] = actions.file_tab,
      },
    },
  },
})

-- more recs
vim.keymap.set("n", "gr", tele.lsp_references)
vim.keymap.set("n", "gd", tele.lsp_definitions)
vim.keymap.set("n", "gI", tele.lsp_implementations)

-- git status
vim.api.nvim_create_user_command("Gs", "Telescope git_status", {})
-- even better git status?
-- vim.api.nvim_create_user_command("Gs", "DiffviewOpen", {})
-- git diff (current file)
vim.api.nvim_create_user_command("Gd", "Gitsigns diffthis", {})

-- I like <Leader>c for comment/uncomment. `gc` comes from Comment.nvim, so we need `remap=true`
vim.keymap.set({"n", "v"}, "<Leader>c", "gc", { remap = true, desc = "comment/uncomment" })

-- Toggle tree
vim.keymap.set({"n","v"}, "<Leader>n", "<cmd>Neotree toggle<CR>", { silent = true })
vim.keymap.set({"n","v"}, "<Leader>N", "<cmd>Neotree reveal<CR>", { silent = true })

-- Aerial is sweet
vim.keymap.set({"n","v"}, "<Leader>a", "<cmd>AerialToggle<CR>", { silent = true })

-- Make Y work like D, C, etc
vim.keymap.set('n', 'Y', 'y$')

-- Copy & paste to system clipboard with <Leader>y and <Leader>p
vim.keymap.set('n', '<Leader>y', '"+y')
vim.keymap.set('n', '<Leader>Y', '"+y$')
vim.keymap.set('n', '<Leader>d', '"+d')
vim.keymap.set('n', '<Leader>p', '"+p')
vim.keymap.set('n', '<Leader>P', '"+P')
vim.keymap.set('v', '<Leader>y', '"+y')
vim.keymap.set('v', '<Leader>Y', '"+y$')
vim.keymap.set('v', '<Leader>d', '"+d')
vim.keymap.set('v', '<Leader>p', '"+p')
vim.keymap.set('v', '<Leader>P', '"+P')

-- when pasting in visual mode, don't overwrite the default register
vim.keymap.set("v", "p", "pgvygv<Esc>")

-- in visual mode, * searches for the selected text
vim.keymap.set("v", "*", function()
  local saved_reg = vim.fn.getreg("z")
  local saved_type = vim.fn.getregtype("z")

  vim.cmd('normal! "zy')
  local text = vim.fn.escape(vim.fn.getreg("z"), [[\/.*$^~[]])

  vim.fn.setreg("/", text)

  vim.fn.setreg("z", saved_reg, saved_type)
  vim.cmd("normal! n")
end)

-- unhighlight search results with `\n`
vim.keymap.set("n", "\\n", "<cmd>nohlsearch<CR>", { silent = true })


vim.api.nvim_create_user_command('Blit', function(opts)
  -- 1. Get the remote origin URL and sanitize it to a web link
  local remote = vim.fn.systemlist('git config --get remote.origin.url')[1]
  if not remote or remote == "" then
    vim.notify("No git remote origin found", vim.log.levels.ERROR)
    return
  end
  remote = remote:gsub('%.git$', ''):gsub('git@github%.com:', 'https://github.com/')

  -- 2. Get current commit hash (for a true permalink) and repository root path
  local commit = vim.fn.systemlist('git rev-parse HEAD')[1]
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  
  -- 3. Get the file path relative to the git root
  local current_file = vim.api.nvim_buf_get_name(0)
  local relative_file = current_file:sub(#git_root + 2)

  -- 4. Construct the base URL
  local url = string.format("%s/blob/%s/%s", remote, commit, relative_file)

  -- 5. Detect line numbers (checks if command was run from visual selection)
  if opts.range > 0 then
    local start_line = opts.line1
    local end_line = opts.line2
    if start_line == end_line then
      url = url .. "#L" .. start_line
    else
      url = url .. string.format("#L%d-L%d", start_line, end_line)
    end
  end

  -- 6. Copy to system clipboard and notify
  vim.fn.setreg('+', url)
  vim.notify("Copied: " .. url, vim.log.levels.INFO)
end, {
  range = true,
  desc = "Copy GitHub permalink for current file and commit to clipboard"
})

