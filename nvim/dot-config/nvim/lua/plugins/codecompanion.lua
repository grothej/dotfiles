return {
  'olimorris/codecompanion.nvim',
  init = function()
    require('plugins.codecompanion.fidget-spinner'):init()
  end,
  opts = {
    strategies = {
      chat = {
        adapter = 'ollama',
      },
      inline = {
        adapter = 'ollama',
      },
      cmd = {
        adapter = 'ollama',
      },
    },
    adapters = {
      ollama = function()
        return require('codecompanion.adapters').extend('ollama', {
          name = 'ollama', -- Geben Sie dem Adapter einen Namen
          schema = {
            model = {
              default = 'qwen2.5-coder:7b',
            },
            num_ctx = {
              default = 16384,
            },
            num_predict = {
              default = -1,
            },
          },
          env = {
            url = 'http://localhost:11434',
          },
          headers = {
            ['Content-Type'] = 'application/json',
          },
          parameters = {
            sync = true,
          },
        })
      end,
    },
    log_level = 'DEBUG',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    { '<leader>ac', '<cmd>CodeCompanionChat Toggle<CR>', desc = 'Toggle Companion Chat' },
    { '<leader>aa', '<cmd>CodeCompanionActions<CR>', desc = 'Open Companion Actions' },
  },
}
