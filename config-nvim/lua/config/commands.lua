-- git status
vim.api.nvim_create_user_command("Gs", "Telescope git_status", {})

-- even better git status?
-- vim.api.nvim_create_user_command("Gs", "DiffviewOpen", {})

-- git diff (current file)
vim.api.nvim_create_user_command("Gd", "Gitsigns diffthis", {})

-- Blit
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

