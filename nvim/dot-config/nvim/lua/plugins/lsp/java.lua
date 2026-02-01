-- java specific plugins
return {
  {
    'mfussenegger/nvim-jdtls',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    ft = 'java',
    keys = {
      { '<leader>ju', function() require('jdtls').update_project_config() end, desc = '[J]ava [u]pdate config' },
    },
  },
  {
    'JavaHello/spring-boot.nvim',
    ft = { 'java', 'yaml', 'jproperties' },
    dependencies = {
      'mfussenegger/nvim-jdtls',
    },
    opts = {},
  },
  {
    'elmcgill/springboot-nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-jdtls',
    },
    ft = { 'java', 'jproperties' },
    config = function()
      local springboot_nvim = require 'springboot-nvim'
      vim.keymap.set('n', '<leader>jr', springboot_nvim.boot_run, { desc = 'Spring Boot Run Project' })
      vim.keymap.set('n', '<leader>jc', springboot_nvim.generate_class, { desc = 'Java Create Class' })
      vim.keymap.set('n', '<leader>ji', springboot_nvim.generate_interface, { desc = 'Java Create Interface' })
      vim.keymap.set('n', '<leader>je', springboot_nvim.generate_enum, { desc = 'Java Create Enum' })
      springboot_nvim.setup()
    end,
  },
}
