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

-- Show line numbers
vim.opt.number = true

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
      }
    },
    -- language syntax highlighting
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      build = ':TSUpdate'
    },
    -- sticky header shows your "nesting ancestry"
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

    -- Bunch of LSP stuff (blink copy-paste from chatgpt, make sure it makes sense)
    {
      "mason-org/mason.nvim",
      opts = {},
    },

    {
      "mason-org/mason-lspconfig.nvim",
      dependencies = {
        "mason-org/mason.nvim",
        "neovim/nvim-lspconfig",
      },
      opts = {
        ensure_installed = {
          "bashls",
          "clangd",
          "gopls",
          "lua_ls",
          "pyright",
          "rust_analyzer",
          "terraformls",
          "yamlls",
        },
        automatic_enable = true;
      },
    },

    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "mason-org/mason-lspconfig.nvim",
      },
      config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()

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
      end,
    },

    -- {
    --   'saghen/blink.cmp',
    --   dependencies = {
    --     'saghen/blink.lib',
    --     -- optional: provides snippets for the snippet source
    --     'rafamadriz/friendly-snippets',
    --   },
    --   build = function()
    --     -- build the fuzzy matcher, optionally add a timeout to `pwait(timeout_ms)`
    --     -- you can use `gb` in `:Lazy` to rebuild the plugin as needed
    --     require('blink.cmp').build():pwait()
    --   end,
    --
    --   ---@module 'blink.cmp'
    --   ---@type blink.cmp.Config
    --   opts = {
    --     -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    --     -- 'super-tab' for mappings similar to vscode (tab to accept)
    --     -- 'enter' for enter to accept
    --     -- 'none' for no mappings
    --     --
    --     -- All presets have the following mappings:
    --     -- C-space: Open menu or open docs if already open
    --     -- C-n/C-p or Up/Down: Select next/previous item
    --     -- C-e: Hide menu
    --     -- C-k: Toggle signature help (if signature.enabled = true)
    --     --
    --     -- See :h blink-cmp-config-keymap for defining your own keymap
    --     keymap = { preset = 'default' },
    --
    --     -- (Default) Only show the documentation popup when manually triggered
    --     completion = { documentation = { auto_show = false } },
    --
    --     -- (Default) list of enabled providers defined so that you can extend it
    --     -- elsewhere in your config, without redefining it, due to `opts_extend`
    --     sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    --
    --     -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    --     -- You may use a lua implementation instead by using `implementation = "lua"`
    --     -- See the fuzzy documentation for more information
    --     fuzzy = { implementation = "rust" }
    --   },
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
vim.keymap.set('n', '<Leader>o', tele.find_files)
-- telescope's recommendations
vim.keymap.set('n', '<Leader>ff', tele.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<Leader>fg', tele.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<Leader>fb', tele.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<Leader>fh', tele.help_tags, { desc = 'Telescope help tags' })

-- more recs
vim.keymap.set("n", "gr", tele.lsp_references)
vim.keymap.set("n", "gd", tele.lsp_definitions)

-- I like <Leader>c for comment/uncomment. `gc` comes from Comment.nvim, so we need `remap=true`
vim.keymap.set("n", "<Leader>c", "gc", { remap = true })
vim.keymap.set("v", "<Leader>c", "gc", { remap = true })

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
