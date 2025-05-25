-- [[ Basic Keymaps ]]
--

vim.keymap.set('n', '<leader>tc', '<cmd>tabc<CR>')
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- copy whole file content
vim.keymap.set('n', 'yw', '<cmd>%y<CR>', { desc = '[y]' })

-- sort selected lines
vim.keymap.set('v', 'grs', '<cmd>sort<CR>', { desc = '[s]ort' })

-- qf list and loc list navigation mappings
--- execute the given command for a qf list or loc list of current window
--- @param cmd string
function navigate_list(cmd)
  local loc_list_length = vim.fn.getloclist(0, { size = 1 }).size
  local qf_list_length = vim.fn.getqflist({ size = 1 }).size

  if loc_list_length > 0 then
    vim.cmd('l' .. cmd)
  end

  if qf_list_length > 0 then
    vim.cmd('c' .. cmd)
  end
end
vim.keymap.set('n', '<leader>c', function()
  navigate_list 'close'
end, { desc = 'close list' })
vim.keymap.set('n', '<C-n>', function()
  navigate_list 'next'
end, { desc = 'next entry in list' })
vim.keymap.set('n', '<C-p>', function()
  navigate_list 'prev'
end, { desc = 'next entry in list' })

--  Schedule the setting after `UiEnter` because it can increase startup-time.
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Diagnostic keymaps
-- open loclist with diagnostics and jump to first entry in list
-- then focus on the initial window insead of the loclist window
vim.keymap.set('n', '<leader>q', function()
  vim.diagnostic.setloclist()

  vim.cmd 'wincmd p'

  local loclist = vim.fn.getloclist(0)
  if #loclist > 0 then
    vim.cmd 'll 1'
  end
end, { desc = 'Open diagnostic [Q]uickfix list and return focus' })
