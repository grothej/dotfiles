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
require('lazy').setup({
  { 'NMAC427/guess-indent.nvim', opts = {} }, -- Detect tabstop and shiftwidth automatically

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      preset = 'helix',
      delay = 300,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>g', group = '[G]it' },
        { '<leader>p', group = '[P]rojects' },
      },
    },
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            '^.gitlab-ci-local/',
            '^.go/',
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sf', builtin.git_files, { desc = '[S]earch Git [F]iles' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sb', builtin.git_branches, { desc = '[S]earch [B]ranches' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
    end,
  },

  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  { import = 'plugins' },
  { import = 'plugins.lsp' },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true, auto_show_delay_ms = 500, window = { border = 'rounded' } },
        menu = {
          border = 'rounded',
        },
        ghost_text = {
          enabled = true,
        },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin-mocha'
    end,
  },
  -- {
  --   'rebelot/kanagawa.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   config = function()
  --     require('kanagawa').load 'wave'
  --   end,
  -- },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.surround').setup()
      require('mini.pairs').setup()
      require('mini.move').setup()

      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'yaml', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'java' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  {
    'nvim-tree/nvim-tree.lua',
    keys = {
      { '<leader>tt', ':NvimTreeFindFileToggle<CR>', desc = '[T]oggle Nvim[T]ree' },
      { '<leader>tf', ':NvimTreeFocus<CR>', desc = '[T]oggle Nvim[T]ree [f]ocus ' },
    },
    opts = {
      disable_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = {
          enable = true,
        },
      },
      modified = {
        enable = true,
      },
      filters = {
        custom = {},
      },
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'sindrets/diffview.nvim',
        lazy = false,
        keys = {
          { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = '[G]it diffview' },
        },
      },
      'nvim-telescope/telescope.nvim',
    },
    opts = {},
    keys = {
      { '<leader>gg', '<cmd>Neogit kind=floating<CR>', desc = '[G]it' },
      { '<leader>gp', '<cmd>Neogit pull<CR>', desc = '[G]it [p]ull' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {},
    lazy = false,
    keys = {
      { '<leader>gbb', '<cmd>Gitsigns blame<CR>', desc = '[G]it [b]lame [b]uffer' },
      { '<leader>gbl', '<cmd>Gitsigns blame_line<CR>', desc = '[G]it [b]lame [l]ine' },
      { '<leader>ghp', '<cmd>Gitsigns preview_hunk_inline<CR>', desc = '[G]it [h]unk [p]review' },
      { '<leader>ghl', '<cmd>Gitsigns setqflist<CR>', desc = '[G]it [h]unks [l]ist' },
      { '<leader>gha', '<cmd>Gitsigns stage_hunk<CR>', desc = '[G]it [h]unks [a]dd' },
      { '<leader>ghr', '<cmd>Gitsigns undo_stage_hunk<CR>', desc = '[G]it [h]unks [r]estore' },
    },
  },
  {
    'coffebar/neovim-project',
    opts = {
      projects = {
        '~/projects/*',
        '~/IdeaProjects/tc_code/*',
        '~/IdeaProjects/tc_code/intranet/*',
        '~/IdeaProjects/tc_code/corporate-website/*',
        '~/dotfiles/*',
        '~/programming/go-testing/go/',
      },
      picker = {
        type = 'telescope',
      },
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append 'globals' -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim' },
      { 'Shatur/neovim-session-manager' },
    },
    lazy = false,
    priority = 100,
    keys = {
      { '<leader>pp', ':NeovimProjectDiscover<CR>', desc = 'Search for [p]roject from specified patterns' },
      { '<leader>pr', ':NeovimProjectHistory<CR>', desc = 'Search [p]roject from [r]ecent ones' },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim', 'nvim-tree/nvim-web-devicons' }, -- if you use the mini.nvim suite
      opts = {},
    },
  },

  ---@diagnostic disable-next-line: missing-fields
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
