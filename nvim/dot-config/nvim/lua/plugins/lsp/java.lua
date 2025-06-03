-- java specific plugins
return {
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    keys = {
      -- { 'n', '<leader>Jt', '<Cmd>lua require'jdtls'.test_class()<CR>' },
      -- { 'n', '<leader>Jn', '<Cmd>lua require'jdtls'.test_class()<CR>' },
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
}
