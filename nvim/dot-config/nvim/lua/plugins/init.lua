return {

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
        { '<leader>g', group = '[G]it' },
        { '<leader>p', group = '[P]rojects' },
        { '<leader>g', group = '[G]it' },
        { '<leader>gb', group = '[G]it [b]lame' },
        { '<leader>gh', group = '[G]it [h]unk' },
        { '<leader>l', group = '[L]int' },
        { '<leader>a', group = '[A]ssistant' },
        { '<leader>t', group = '[T]est' },
        { '<leader>tt', group = '[T]est [t]oggle' },
        { '<leader>tj', group = '[T]est [j]ump' },
      },
    },
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      local parsers = {
        'bash',
        'c',
        'diff',
        'html',
        'yaml',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'java',
        'terraform',
        'go',
        'javascript',
      }
      require('nvim-treesitter').setup()

      vim.defer_fn(function()
        require('nvim-treesitter').install(parsers):wait(300000)
      end, 0)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'codecompanion' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim', 'nvim-tree/nvim-web-devicons' }, -- if you use the mini.nvim suite
    opts = {},
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = {
      { '<leader>o', '<cmd>Oil --float<CR>', desc = 'Open tree' },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    lazy = false,
    version = '*',
    opts = {
      open_mapping = [[<C-t>]],
      autochdir = true,
      insert_mappings = false,
    },
    keys = {
      { '<esc>', [[<C-\><C-n>]], mode = 't' },
      { '<C-h>', [[<C-\><C-n><cmd>wincmd k<CR>]], mode = 't' },
    },
  },
  {
    'chrisgrieser/nvim-origami',
    event = 'VeryLazy',
    opts = {}, -- needed even when using default config

    -- recommended: disable vim's auto-folding
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
  },
}
