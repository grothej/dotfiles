return {
  {
    'someone-stole-my-name/yaml-companion.nvim',
    requires = {
      { 'neovim/nvim-lspconfig' },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim' },
    },
    config = function()
      require('telescope').load_extension 'yaml_schema'
    end,
  },
  {
    'b0o/schemastore.nvim',
    config = function()
      require('lspconfig').yamlls.setup {
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = '',
            },
            -- custom-tags for gitlab-ci
            customTags = {
              '!reference scalar',
              '!reference sequence',
            },
            schemas = require('schemastore').yaml.schemas(),
          },
        },
      }
    end,
  },
}
