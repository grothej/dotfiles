-- basic lua guide for neovim help lua-guide Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- [[ Setting options ]]

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.opt.winborder = 'rounded'
-- Make line numbers default
vim.opt.number = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- automatically write to buffer
vim.opt.autowrite = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

vim.opt.termguicolors = true

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.opt.confirm = true

-- default tab options
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

-- disable mouse support
vim.opt.mouse = ''

-- Enable break indent
vim.opt.breakindent = true

-- automatic intendation
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.visualbell = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

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

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
require('lazy').setup {
  { import = 'plugins' },
  { import = 'plugins.lsp' },
}
