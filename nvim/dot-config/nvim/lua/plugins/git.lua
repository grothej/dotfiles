return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'esmuellert/codediff.nvim',
        dependencies = { 'MunifTanjim/nui.nvim' },
        cmd = 'CodeDiff',
        keys = {
          { '<leader>gd', '<cmd>CodeDiff<CR>', desc = '[G]it [d]iff' },
        },
      },
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      graph_style = 'unicode',
      telescope_sorter = function()
        return require('telescope').extensions.fzf.native_fzf_sorter()
      end,
      kind = 'floating',
      log_view = {
        kind = 'tab',
      },
      rebase_editor = {
        kind = 'tab',
      },
    },
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
}
