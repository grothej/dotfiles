return {
  {
    'b0o/schemastore.nvim',
    lazy = false,
    config = function()
      vim.lsp.config('yamlls', {
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = '',
            },
            schemas = require('schemastore').yaml.schemas {
              extra = {
                {
                  name = 'Bitnami Sealed Secret',
                  description = 'Bitnami Sealed Secret',
                  fileMatch = { '*sealed*.y*ml' },
                  url = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/refs/heads/main/bitnami.com/sealedsecret_v1alpha1.json',
                },
              },
            },
            customTags = {
              '!reference scalar',
              '!reference sequence',
            },
          },
        },
      })
      vim.lsp.enable 'yamlls'
    end,
  },
  {
    'git@github.com:grothej/k8s-schema-helper.nvim',
    opts = {},
    ft = 'yaml',
  },
}
