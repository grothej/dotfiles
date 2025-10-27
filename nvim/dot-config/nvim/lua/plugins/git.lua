return {
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
        config = function()
          require('diffview').setup {
            merge_tool = {
              layout = 'diff3_mixed',
            },
          }
        end,
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
