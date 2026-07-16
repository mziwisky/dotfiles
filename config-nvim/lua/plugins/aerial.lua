return {
  'stevearc/aerial.nvim',
  opts = {
    autojump = true,
    attach_mode = "global",
    layout = {
      default_direction = "right",
      placement = "edge",
    },
  },
  -- Optional dependencies
  dependencies = {
     "nvim-treesitter/nvim-treesitter",
     "nvim-tree/nvim-web-devicons"
  },
}
-- TODO: not sure yet what hotkeys i want to use for this.  maybe Leader-m, but then my current
-- Leader-m (open recent files) needs a new map, maybe Leader-O? For now, trying Leader-a
