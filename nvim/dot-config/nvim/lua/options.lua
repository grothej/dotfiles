-- [[ Basic Options ]]
--

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

-- automatically change cwd to buffer path
vim.opt.autochdir = true

-- automatic intendation
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.visualbell = true

-- spellcheck
vim.opt.spell = true
-- if the language is not automatically downloaded manually copy from:
-- https://ftp.nluug.nl/vim/runtime/spell/
vim.opt.spelllang = { 'en_us', 'de' }
