-- It's a statusline!

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

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
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
  }
}
