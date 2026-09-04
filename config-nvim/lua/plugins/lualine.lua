-- It's a statusline!

-- Which python env is active, for python buffers. venv-selector's own "venv-selector"
-- component shows the venv dir's own name, which is ".venv" for every project in a
-- monorepo -- so show the project directory holding it instead.
--
-- This is opinionated, expecting a local `.venv` for each project root, so if it doesn't find one
-- it appends a "(not <this project>)" warning to the message. Might prove to be noisy outside of my
-- day job. We'll see.
local function python_venv_status()
  local function get_str()
    local venv = require("venv-selector").venv()
    if not venv or venv == "" then
      return "󰈺 no venv"
    end
    local project = vim.fn.fnamemodify(venv, ":h:t")
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local root = client.config.root_dir
      if root and root ~= vim.fn.fnamemodify(venv, ":h") then
        return "󰈺 " .. project .. " (not " .. vim.fn.fnamemodify(root, ":t") .. ")"
      end
    end
    return "󰈺 " .. project
  end
  return {
    get_str,
    cond = function()
      return vim.bo.filetype == "python"
    end,
  }
end

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
        python_venv_status(),
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
