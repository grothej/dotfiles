return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin-mocha'
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = true,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      require('kanagawa').load 'wave'
    end,
  },
}
