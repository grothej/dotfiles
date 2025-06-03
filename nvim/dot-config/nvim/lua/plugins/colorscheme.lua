return {
  {
    'catppuccin/nvim',
    -- lazy = true,
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'auto', -- latte, frappe, macchiato, mocha
        transparent_background = true, -- disables setting the background color.
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'thesimonho/kanagawa-paper.nvim',
    lazy = true,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd 'colorscheme kanagawa-paper-ink'
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = true,
    priority = 1000,
    config = function()
      require('kanagawa').load 'wave'
    end,
  },
}
