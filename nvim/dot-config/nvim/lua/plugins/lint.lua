return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        javascript = { 'eslint_d' },
        java = {},
        typescript = { 'eslint_d' },
        go = { 'golangcilint' },
        markdown = { 'markdownlint' },
        yaml = { 'yamllint' },
        terraform = { 'tflint' },
        dockerfile = { 'hadolint' },
        bash = { 'shellcheck' },
        makefile = { 'checkmake' },
      }
      -- add cspell for all known languages
      -- for ft, _ in pairs(lint.linters_by_ft) do
      --   table.insert(lint.linters_by_ft[ft], 'cspell')
      -- end

      -- lint.linters_by_ft['go'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })

      vim.keymap.set('n', '<leader>ll', function()
        lint.try_lint()
      end, { desc = '[L ]int current [b]uffer' })

      vim.keymap.set('n', '<leader>ls', function()
        local linters = require('lint').get_running()
        if #linters == 0 then
          print '󰦕'
        end
        vim.print(linters)
      end, { desc = '[l]inters [s]how' })
    end,
  },
}
