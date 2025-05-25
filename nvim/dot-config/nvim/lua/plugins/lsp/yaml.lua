return {
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
