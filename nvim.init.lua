-- TODO: check out the plugins at https://vineeth.io/posts/neovim-setup, see which ones i like

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

-- 0.5s (not 4s) to fire CursorHold autocommands. I used to have one to pop up
-- code diagnostics, now I have none, but this seems like a good default anyway.
vim.opt.updatetime = 500


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
    -- TODO: read these docs, want to learn what else it does
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

        -- TODO: these are blind copy-pastes, decide whether i really want them. And note that `gd` is overridden below (not sure which one takes precedence, actually)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
        vim.keymap.set("n", "gr", vim.lsp.buf.references)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation)

        vim.keymap.set("n", "K", vim.lsp.buf.hover)

        vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename)
        vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action)

        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
        vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float)

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
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.cmd.colorscheme "catppuccin-mocha"

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
    lualine_x = { "encoding", "fileformat", "filetype" },
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

-- write, quit
vim.keymap.set({'n','v'}, '<Leader>w', '<cmd>w<CR>')
vim.keymap.set({'n','v'}, "<Leader>q", "<cmd>q<CR>")

-- quick splits
vim.keymap.set({'n','v'}, "<Leader>s", "<cmd>sp<CR>")
vim.keymap.set({'n','v'}, '<Leader>v', '<cmd>vsp<CR>')

local tele = require('telescope.builtin')
-- my muscle memory
vim.keymap.set('n', '<Leader>o', tele.find_files, { desc = 'Find file' })
vim.keymap.set('n', '<Leader>m', tele.oldfiles, { desc = 'Find recent file'} )
vim.keymap.set('n', '<Leader>g', tele.grep_string, { desc = 'Grep word under cursor' })
vim.keymap.set('v', '<Leader>g', tele.grep_string, { desc = 'Grep current selection' })
-- telescope's recommendations
vim.keymap.set('n', '<Leader>ff', tele.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<Leader>fg', tele.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<Leader>fb', tele.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<Leader>fh', tele.help_tags, { desc = 'Telescope help tags' })

-- more natural preview scrolling
local tele_actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = tele_actions.preview_scrolling_left,
        ["<C-l>"] = tele_actions.preview_scrolling_right,
      },
      n = {
        ["<C-h>"] = tele_actions.preview_scrolling_left,
        ["<C-l>"] = tele_actions.preview_scrolling_right,
      },
    },
  },
})

-- more recs
vim.keymap.set("n", "gr", tele.lsp_references)
vim.keymap.set("n", "gd", tele.lsp_definitions)

-- git status
vim.api.nvim_create_user_command("Gs", "Telescope git_status", {})
-- git diff
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

