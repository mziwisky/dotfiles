return {
  'nvim-telescope/telescope.nvim', version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    local builtin = require('telescope.builtin')
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

    require('telescope').setup({
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

    -- my muscle memory
    vim.keymap.set('n', '<Leader>o', builtin.find_files, { desc = 'Find file (Tele)' })
    vim.keymap.set('n', '<Leader>m', builtin.oldfiles, { desc = 'Find recent file (Tele)'} )

    vim.keymap.set('n', '<Leader>g', builtin.grep_string, { desc = 'Grep word under cursor (Tele)' })
    -- -- haven't decided yet if i want Space-g to be case sensitive... if i do, this is how:
    -- vim.keymap.set('n', '<Leader>g', function()
    --   builtin.grep_string({additional_args = { '--case-sensitive' } })
    -- end, { desc = 'Grep word under cursor (Case sensitive)' })

    vim.keymap.set('v', '<Leader>g', builtin.grep_string, { desc = 'Grep current selection (Tele)' })
    vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = 'Show references (Tele)' })
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'Show definitions (Tele)' })
    vim.keymap.set('n', 'gI', builtin.lsp_implementations, { desc = 'Show implementations (Tele)' })

    -- telescope's recommendations
    vim.keymap.set('n', '<Leader>ff', builtin.find_files, { desc = 'find files (Tele)' })
    vim.keymap.set('n', '<Leader>fg', builtin.live_grep, { desc = 'live grep (Tele)' })
    vim.keymap.set('n', '<Leader>fb', builtin.buffers, { desc = 'buffers (Tele)' })
    vim.keymap.set('n', '<Leader>fh', builtin.help_tags, { desc = 'help tags (Tele)' })
  end,
}
