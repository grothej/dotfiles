return {
  {
    'b0o/schemastore.nvim',
    lazy = false,
    config = function()
      require('lspconfig').yamlls.setup {
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = '',
            },
          },
        },
      }
    end,
  },
  {
    'someone-stole-my-name/yaml-companion.nvim',
    requires = {
      { 'neovim/nvim-lspconfig' },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim' },
    },
    keys = {
      { '<leader>sy', '<cmd>Telescope yaml_schema<CR>', desc = '[S]earch [y]aml schemas' },
    },
    config = function()
      local cfg = require('yaml-companion').setup {
        -- schemas available in Telescope picker
        schemas = {
          -- not loaded automatically, manually select with
          -- :Telescope yaml_schema
          {
            name = 'Argo CD Application',
            uri = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json',
          },
          {
            name = 'SealedSecret',
            uri = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json',
          },
          -- schemas below are automatically loaded, but added
          -- them here so that they show up in the statusline
          -- see https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/api/json/catalog.json for schemas
          {
            name = 'Kustomization',
            uri = 'https://json.schemastore.org/kustomization.json',
          },
          {
            name = 'GitHub Workflow',
            uri = 'https://json.schemastore.org/github-workflow.json',
          },
          {
            name = 'gitlab-ci',
            uri = 'https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json',
          },
        },

        lspconfig = {
          settings = {
            yaml = {
              validate = true,
              schemaStore = {
                enable = false,
                url = '',
              },

              customTags = {
                '!reference scalar',
                '!reference sequence',
              },
              -- schemas from store, matched by filename
              -- loaded automatically
              schemas = require('schemastore').yaml.schemas {
                select = {
                  'kustomization.yaml',
                  'GitHub Workflow',
                  'gitlab-ci',
                },
              },
            },
          },
        },
      }
      require('lspconfig')['yamlls'].setup(cfg)
      -- vim.lsp.config('yamlls', cfg)
      -- :Telescope yaml_schema
      require('telescope').load_extension 'yaml_schema'
    end,
  },
}
