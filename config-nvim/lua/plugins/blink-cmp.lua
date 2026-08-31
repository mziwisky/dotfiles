return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'saghen/blink.lib',
      -- optional: provides snippets for the snippet source
      'rafamadriz/friendly-snippets',
    },
    build = function()
      -- build the fuzzy matcher, optionally add a timeout to `pwait(timeout_ms)`
      -- you can use `gb` in `:Lazy` to rebuild the plugin as needed
      require('blink.cmp').build():pwait()
    end,

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'super-tab',
        ['<C-j>'] = { 'select_next' },
        -- C-k is the default for 'show_signature', but i also like it for 'select_prev' when the
        -- menu is open, so this is how we get it to do both
        ['<C-k>'] = { 'select_prev', 'show_signature', 'hide_signature', 'fallback' },
        ['<C-l>'] = { 'hide' },
      },

      completion = {
        documentation = {
          auto_show = true,
        },
        menu = {
          auto_show = true,
        },
      },

      signature = {
        enabled = true,
        window = {
          show_documentation = true,
        },
      },

      -- (Default) list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"`
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "rust" }
    },
  }
}
