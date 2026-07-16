-- write, quit
vim.keymap.set({'n','v'}, '<Leader>w', '<cmd>w<CR>')
vim.keymap.set({'n','v'}, "<Leader>q", "<cmd>q<CR>")

-- better movement
vim.keymap.set('n', 'j', [[(v:count > 1 ? 'm`' . v:count : v:count == 0 ? 'g' : '') . 'j']], { expr = true, desc = 'down' })
vim.keymap.set('n', 'k', [[(v:count > 1 ? 'm`' . v:count : v:count == 0 ? 'g' : '') . 'k']], { expr = true, desc = 'up' })
vim.keymap.set('x', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'down' })
vim.keymap.set('x', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'up' })

-- quick splits
vim.keymap.set({'n','v'}, "<Leader>s", "<cmd>sp<CR>")
vim.keymap.set({'n','v'}, '<Leader>v', '<cmd>vsp<CR>')

-- Force built-in '*' to be case-sensitive by appending \C
vim.keymap.set('n', '*', function()
  local word = vim.fn.expand('<cword>')
  vim.fn.setreg('/', '\\<' .. word .. '\\>\\C')
  vim.opt.hlsearch = true
  -- Move to the next match manually
  local success, _ = pcall(vim.cmd, 'normal! n')
  if not success then
    print("Pattern not found: " .. word)
  end
end, { desc = "Case-sensitive word search forward" })

-- Force built-in '#' to be case-sensitive by appending \C
vim.keymap.set('n', '#', function()
  local word = vim.fn.expand('<cword>')
  vim.fn.setreg('/', '\\<' .. word .. '\\>\\C')
  vim.opt.hlsearch = true
  -- Move to the previous match manually
  local success, _ = pcall(vim.cmd, 'normal! N')
  if not success then
    print("Pattern not found: " .. word)
  end
end, { desc = "Case-sensitive word search backward" })


-- I like <Leader>c for comment/uncomment. `gc` comes from Comment.nvim, so we need `remap=true`
vim.keymap.set({"n", "v"}, "<Leader>c", "gc", { remap = true, desc = "comment/uncomment" })

-- Toggle tree
vim.keymap.set({"n","v"}, "<Leader>n", "<cmd>Neotree toggle<CR>", { silent = true })
vim.keymap.set({"n","v"}, "<Leader>N", "<cmd>Neotree reveal<CR>", { silent = true })

-- Aerial is sweet
vim.keymap.set({"n","v"}, "<Leader>a", "<cmd>AerialToggle<CR>", { silent = true })

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

