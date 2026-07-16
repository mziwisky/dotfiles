-- Treesitter -- syntax highlighting (and indentation)
-- NOTE: this depends on the treesitter cli (`brew install tree-sitter-cli`)

-- SEE ALSO: ../config/ftplugin.lua -- treesitter has to be started manually in each buffer that you
-- want it enabled in, so that file sets up a FileType autocommand to do just that. In general, the
-- settings table there must be kept up to date with the parsers here.

-- jsonc uses the json parser
vim.treesitter.language.register('json', { 'jsonc' })

-- zsh uses the bash parser
vim.treesitter.language.register('bash', { 'zsh' })

local parsers = {
  'bash',
  'css',
  'diff',
  'editorconfig',
  'fish',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'go',
  'gomod',
  'gosum',
  'gowork',
  'hcl',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'latex',
  'lua',
  'make',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'regex',
  'rust',
  'scss',
  'toml',
  'tsx',
  'typescript',
  'typst',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
  'yang',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install(parsers)
    end,
  },
  -- sticky header shows your "nesting ancestry"
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = { mode = 'topline' }
  },
}

-- https://github.com/ThorstenRhau/neovim/blob/main/lua/plugins/treesitter.lua has some decent ideas
-- i might want to steal, commented out below

-- require('nvim-treesitter').setup({
--   install_dir = vim.fn.stdpath('data') .. '/site',
-- })
--
-- -- Textobjects (selection handled by mini.ai, movement by treesitter-textobjects)
-- require('nvim-treesitter-textobjects').setup({
--   move = {
--     set_jumps = true,
--   },
-- })
--
-- local map = vim.keymap.set
--
-- -- Movement
-- map({ 'n', 'x', 'o' }, ']f', function()
--   require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
-- end, { desc = 'next function start' })
-- map({ 'n', 'x', 'o' }, '[f', function()
--   require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
-- end, { desc = 'previous function start' })
-- map({ 'n', 'x', 'o' }, ']F', function()
--   require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
-- end, { desc = 'next function end' })
-- map({ 'n', 'x', 'o' }, '[F', function()
--   require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
-- end, { desc = 'previous function end' })
-- map({ 'n', 'x', 'o' }, ']k', function()
--   require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
-- end, { desc = 'next class start' })
-- map({ 'n', 'x', 'o' }, '[k', function()
--   require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
-- end, { desc = 'previous class start' })
-- map({ 'n', 'x', 'o' }, ']K', function()
--   require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
-- end, { desc = 'next class end' })
-- map({ 'n', 'x', 'o' }, '[K', function()
--   require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
-- end, { desc = 'previous class end' })
--
-- -- Context
-- require('treesitter-context').setup({
--   line_numbers = true,
--   max_lines = 3,
--   min_window_height = 20,
-- })
--
-- map('n', 'gC', function()
--   require('treesitter-context').go_to_context()
-- end, { desc = 'go to context' })
