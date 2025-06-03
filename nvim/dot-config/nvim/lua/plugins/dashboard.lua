return {
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    enabled = true,
    config = function()
      local dashboard_theme = require 'alpha.themes.dashboard'

      local logo = [[
      
      
                    a8888b.
                   d888888b.
                   8P"YP"Y88
                   8|o||o|88
                   8'    .88
                   8`._.' Y8.
                  d/      `8b.
                .dP   .     Y8b.
               d8:'   "   `::88b.
              d8"           `Y88b
             :8P     '       :888
              8a.    :      _a88P
            ._/"Yaa_ :    .| 88P|
            \    YP"      `| 8P  `.
 __    __   /     \._____.d|    .'        __                  
|  \  |  \  `--..__)       `._.'         |  \              
| $$\ | $$  ______    ______   __     __  \$$ ______ ____  
| $$$\| $$ /      \  /      \ |  \   /  \|  \|      \    \ 
| $$$$\ $$|  $$$$$$\|  $$$$$$\ \$$\ /  $$| $$| $$$$$$\$$$$\
| $$\$$ $$| $$    $$| $$  | $$  \$$\  $$ | $$| $$ | $$ | $$
| $$ \$$$$| $$$$$$$$| $$__/ $$   \$$ $$  | $$| $$ | $$ | $$
| $$  \$$$ \$$     \ \$$    $$    \$$$$  | $$| $$ | $$ | $$
 \$$   \$$  \$$$$$$$  \$$$$$$      \$`    \$$ \$$  \$$  \$$




  ]]
      dashboard_theme.section.header.val = vim.split(logo, '\n')
      vim.api.nvim_set_hl(0, 'AlphaHeaderGreen', { fg = '#50fa7b', bold = true })

      -- Buttons Section
      dashboard_theme.section.buttons.val = {
        dashboard_theme.button('f', ' Find file', '<cmd>Telescope find_files<CR>'),
        dashboard_theme.button('r', ' Recent files', '<cmd>Telescope oldfiles <CR>'),
        dashboard_theme.button('p', ' Projects', '<cmd>Telescope project<CR>'),
        dashboard_theme.button('n', ' New file', '<cmd>edit<CR>'),
        dashboard_theme.button('e', '󰏔 Extensions', '<cmd>Lazy<CR>'),
        dashboard_theme.button('l', "󰌞 LSP's", '<cmd>Mason<CR>'),
        dashboard_theme.button('q', ' Close', '<cmd>q<CR>'),
      }
      dashboard_theme.section.buttons.opts.hl = 'AlphaButtons'

      -- Layout
      dashboard_theme.opts.layout = {
        { type = 'padding', val = 4 }, -- Upper margin
        dashboard_theme.section.header,
        { type = 'padding', val = 2 }, -- Space between logo and buttons
        dashboard_theme.section.buttons,
        { type = 'padding', val = 1 }, -- Space between buttons and recent files
        dashboard_theme.section.footer,
      }

      -- Lazy Loading
      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          once = true,
          pattern = 'AlphaReady',
          callback = function()
            require('lazy').show()
          end,
        })
      end

      -- Set the dashbaord
      require('alpha').setup(dashboard_theme.opts)

      -- Draw Footer After Startup
      vim.api.nvim_create_autocmd('User', {
        once = true,
        pattern = 'LazyVimStarted',
        callback = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

          -- Footer
          dashboard_theme.section.footer.val = '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms'
          pcall(vim.cmd.AlphaRedraw)
          dashboard_theme.section.footer.opts.hl = 'AlphaFooter'
        end,
      })
    end,
  },
}
