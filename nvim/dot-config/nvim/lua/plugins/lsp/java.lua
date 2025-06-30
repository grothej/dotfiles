-- java specific plugins
return {
  {
    'mfussenegger/nvim-jdtls',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    ft = 'java',
    keys = {
      { '<leader>jtc', '<Cmd>lua require("jdtls").test_class()<CR>', desc = '[j]ava [t]est [c]lass' },
      { '<leader>jtm', '<Cmd>lua require("jdtls").test_nearest_method()<CR>', desc = '[j]ava [t]est [m]ethod' },
      { '<leader>jd', '<Cmd>JdtUpdateDebugConfigs<CR>', desc = '[j]ava [d]ebug config' },
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
