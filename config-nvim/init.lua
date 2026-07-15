-- HOT TIPS
--
--   Ctrl-O / Ctrl-I -- jump backwards/forwards through the jump list. "jumps" include `:e`, `gd`, `gr`, `*`, `n`, etc.
--                      so jumps can be within the same buffer, or to a different buffer. Each pane
--                      has its own jump list.
--
-- CONCEPTS
--   `g` is a prefix namspace Vim uses to multiply its command space without modifier keys. There's no
--   unifying concept for everything under `g`, but _some_ of the commands follow some loose themes.
--   For example, "go":
--      gg      = go to top of file
--      gd / gD = go to definition/declaration
--      gi      = go to last insert position
--   The other theme is "variant of the base command with the same letter". For example:
--      gj / gk = move by display (wrapped) lines instead of real ones
--      gJ      = join lines without inserting a space
--      gn / gN = select the next/prev search match (operable)
--   But then there's also just extra stuff that matches neither theme, e.g. g? = Rot13 encode
--
--   Other prefix namespaces include:
--    - z — folds and vertical scroll positioning (zz, zf, zo, za, ...)
--    - [ / ] — jump backward/forward between pairs of things ([c/]c hunks, [d/]d diagnostics, [m/]m methods)
--    - Ctrl-w — window management
--    - " — register selection

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
local mason_languages = {
  "bashls",
  "clangd",
  "gopls",
  "lua_ls",
  "protols",
  "pyright",
  "rust_analyzer",
  "terraformls",
  "ts_ls",
  "yamlls",
}

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


local ibl_highlight = {
  "CursorColumn",
  "Whitespace",
}

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- cool theme
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      opts = { auto_integrations = true },
    },
    -- like CtrlP, but much more?
    {
      'nvim-telescope/telescope.nvim', version = '*',
      dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      },
    },
    -- language syntax highlighting
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      build = ':TSUpdate'
    },
    -- sticky header shows your "nesting ancestry"
    -- TODO: doesn't seem to work with python?
    {
      'nvim-treesitter/nvim-treesitter-context',
      opts = { mode = 'topline' }
    },
    -- seamless navigation between vim and tmux panes
    {
      "christoomey/vim-tmux-navigator",
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
        "TmuxNavigatorProcessList",
      },
      keys = {
        { "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
      },
    },
    -- NerdTree replacement
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons", -- optional, but recommended
      },
      lazy = false, -- neo-tree will lazily load itself
    },
    -- interactive rg command constructor
    { "mangelozzi/nvim-rgflow.lua" },
    -- Shows indentation bars
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      ---@module "ibl"
      ---@type ibl.config
      opts = {
        -- Configure indentation bars as subtle, alternating bg colors
        indent = { highlight = ibl_highlight, char = "" },
        whitespace = {
          highlight = ibl_highlight,
          remove_blankline_trail = false,
        },
        scope = { enabled = true },
      },
    },
    -- better commenting
    { 'numToStr/Comment.nvim' },
    -- inline git blame (and more)
    -- TODO: read these docs, probably want to customize it more
    {
      'lewis6991/gitsigns.nvim',
      opts = { current_line_blame = true },
    },
    -- a statusline
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    -- like tpope/vim-surround
    {
      "kylechui/nvim-surround",
      version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      -- Optional: See `:h nvim-surround.configuration` and `:h nvim-surround.setup` for details
      -- config = function()
      --     require("nvim-surround").setup({
      --         -- Put your configuration here
      --     })
      -- end
    },
    -- a vim tutor!  delay long enough in a command sequence and it will pop up some help.  we'll see if this is useful or annoying.
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    },
    -- VSCode-like winbar (breadcrumbs @ top bar of each split)
    {
      "utilyre/barbecue.nvim",
      name = "barbecue",
      version = "*",
      dependencies = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons", -- optional dependency
      },
      opts = {
        show_modified = true,
        symbols = {
          modified = "+",
        },
      },
    },
    -- Nice git diffs
    { "sindrets/diffview.nvim" },
    -- Bunch of LSP stuff (started as blind copy-paste from chatgpt, have been refining...)
    { "mason-org/mason.nvim", opts = {} },

    {
      "mason-org/mason-lspconfig.nvim",
      dependencies = {
        "mason-org/mason.nvim",
        "neovim/nvim-lspconfig",
      },
      opts = {
        ensure_installed = mason_languages,
      },
    },

    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "mason-org/mason-lspconfig.nvim",
      },
      config = function()
        -- register "vim" as a known global in all lua files,
        -- just so all the `vim`s in this file don't get marked as problems
        vim.lsp.config("lua_ls", {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        })

        -- TODO: these are blind copy-pastes, decide whether i really want them. And note that `gd` is overridden below
        vim.keymap.set("n", "K", vim.lsp.buf.hover)

        vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename)
        -- TODO: this one conflicts with leader-c for "comment/uncomment around". i usually use
        -- full-line comments, but still not great to have an ambiguous leader-c prefix. maybe i
        -- should try leader-l for LSP-related things? including the built-in `gr*` commands
        -- (see `:h grr` for the list)
        vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action)

        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

        vim.diagnostic.config({
          signs = {
            numhl = {
              [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
              [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
              [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
              [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            },
            text = {
              [vim.diagnostic.severity.ERROR] = "X",
              [vim.diagnostic.severity.HINT] = "?",
              [vim.diagnostic.severity.INFO] = "I",
              [vim.diagnostic.severity.WARN] = "!",
            },
          },
          update_in_insert = true,
          virtual_text = false, -- don't show diagnostics inline...
          virtual_lines = { current_line = true }, -- ...show them underneath, and only for cursor loc
        })

        -- don't show me virtual lines in insert mode...
        vim.api.nvim_create_autocmd("InsertEnter", {
          callback = function()
            vim.diagnostic.config({ virtual_lines = false })
          end,
        })

        -- ...do show them to me in normal mode.
        -- (if even the underlining gets annoying in insert mode, just delete these autocmds
        -- and set `update_in_insert` to false)
        vim.api.nvim_create_autocmd("InsertLeave", {
          callback = function()
            vim.diagnostic.config({ virtual_lines = { current_line = true } })
          end,
        })

        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local bufnr = args.buf

            if client and client.server_capabilities.documentHighlightProvider then
              local hl_group = vim.api.nvim_create_augroup(
                "lsp_document_highlight_" .. bufnr,
                { clear = true }
              )

              vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = hl_group,
                buffer = bufnr,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd("CursorMoved", {
                group = hl_group,
                buffer = bufnr,
                callback = vim.lsp.buf.clear_references,
              })

              -- clean up the group when the buffer's LSP client detaches
              vim.api.nvim_create_autocmd("LspDetach", {
                group = hl_group,
                buffer = bufnr,
                callback = function()
                  vim.api.nvim_clear_autocmds({ group = hl_group, buffer = bufnr })
                end,
              })
            end
          end,
        })
      end,
    },
    -- automatic python virtualenv activation per-buffer, so LSP always has the right context.
    -- monorepo-compatible!
    -- TODO: consider https://github.com/linux-cultist/venv-selector.nvim instead? this one here
    -- seems to work, but that one is more popular, so if this one fails, try that one.
    {
      "jglasovic/venv-lsp.nvim",
      config = function()
        require("venv-lsp").setup()
      end,
    },

    -- -- some random dude's LSP CONFIG that might have some good tidbits? esp for blink.cmp?
    -- "neovim/nvim-lspconfig",
    -- config = function()
    --   require("mason").setup({
    --     registries = { "github:crashdummyy/mason-registry", "github:mason-org/mason-registry" },
    --   })
    --   require("mason-lspconfig").setup()
    --   require("roslyn").setup()
    --   require("blink.cmp").setup({
    --     completion = {
    --       documentation = { auto_show = true },
    --     },
    --     keymap = {
    --       preset = "none",
    --       ["<C-j>"] = { "select_next", "fallback" },
    --       ["<C-k>"] = { "select_prev", "fallback" },
    --       ["<CR>"] = { "select_and_accept" },
    --     },
    --   })
    --
    --   vim.diagnostic.config({
    --     signs = {
    --       numhl = {
    --         [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
    --         [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    --         [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    --         [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
    --       },
    --       text = {
    --         [vim.diagnostic.severity.ERROR] = "X",
    --         [vim.diagnostic.severity.HINT] = "?",
    --         [vim.diagnostic.severity.INFO] = "I",
    --         [vim.diagnostic.severity.WARN] = "!",
    --       },
    --     },
    --     update_in_insert = true,
    --     virtual_text = false,
    --     virtual_lines = { current_line = true },
    --   })
    -- end,
    -- dependencies = {
    --   "seblyng/roslyn.nvim",
    --   "mason-org/mason-lspconfig.nvim",
    --   "mason-org/mason.nvim",
    --   { "saghen/blink.cmp", build = "cargo build --release" },
    -- },

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

