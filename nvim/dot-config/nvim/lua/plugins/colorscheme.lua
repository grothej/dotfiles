return {
  {
    'catppuccin/nvim',
    lazy = true,
    name = 'catppuccin',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin-mocha'
    end,
  },
  {
    'thesimonho/kanagawa-paper.nvim',
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd 'colorscheme kanagawa-paper-ink'
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = true,
    priority = 1000, -- make sure to load this before all the other start plugins.
    config = function()
      require('kanagawa').load 'wave'
    end,
  },
}
