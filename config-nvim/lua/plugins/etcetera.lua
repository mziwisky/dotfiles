-- everything i haven't otherwise categorized yet!
local ibl_highlight = {
  "CursorColumn",
  "Whitespace",
}
return {
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

}
