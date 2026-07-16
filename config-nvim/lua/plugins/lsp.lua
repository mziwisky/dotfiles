-- Bunch of LSP stuff (started as blind copy-paste from chatgpt, have been refining...)

local mason_lang_servers = {
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

return {
  { "mason-org/mason.nvim", opts = {} },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = mason_lang_servers,
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
}
