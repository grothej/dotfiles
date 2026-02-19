return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          path_display = { 'filename_first' },
          hidden = true,
          file_ignore_patterns = {
            '^.git/',
            '^.gitlab-ci-local/',
            '^.go/',
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'project')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', function()
        builtin.help_tags {
          attach_mappings = function(_, map)
            local actions = require 'telescope.actions'
            map('i', '<CR>', actions.select_vertical)
            map('n', '<CR>', actions.select_vertical)
            return true
          end,
        }
      end, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sgf', function()
        builtin.git_files { use_git_root = true }
      end, { desc = '[S]earch [G]it [F]iles' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sb', builtin.git_branches, { desc = '[S]earch [B]ranches' })
      vim.keymap.set('n', '<leader>sc', builtin.git_commits, { desc = '[S]earch [C]ommit' })
      vim.keymap.set('n', '<leader>sp', '<cmd>Telescope project<CR>', { desc = '[S]earch [P]rojects' })

      local function git_root_cwd()
        local git_result = require('telescope.utils').get_os_command_output { 'git', 'rev-parse', '--show-toplevel' }
        local cwd = require('telescope.utils').buffer_dir()
        if git_result and #git_result > 0 and git_result[1] ~= '' then
          cwd = git_result[1]
        end
        return cwd
      end
      vim.keymap.set('n', '<leader>sgr', function()
        require('telescope.builtin').live_grep { cwd = git_root_cwd() }
      end, { desc = '[S]earch by [G][r]ep' })
      vim.keymap.set('n', '<leader>sgg', function()
        require('telescope.builtin').grep_string {
          cwd = git_root_cwd(),
          search = '',
          only_sort_text = true,
          prompt_title = 'Fuzzy Search Git Files',
        }
      end, { desc = '[S]earch [G]it fuzzy [G]rep' })
      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
    end,
  },
  {
    'nvim-telescope/telescope-project.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
  },
}
