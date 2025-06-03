return {
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    enabled = true,
    config = function()
      local dashboard_theme = require 'alpha.themes.dashboard'

      local logo = [[
 __    __                                 __               
|  \  |  \                               |  \              
| $$\ | $$  ______    ______   __     __  \$$ ______ ____  
| $$$\| $$ /      \  /      \ |  \   /  \|  \|      \    \ 
| $$$$\ $$|  $$$$$$\|  $$$$$$\ \$$\ /  $$| $$| $$$$$$\$$$$\
| $$\$$ $$| $$    $$| $$  | $$  \$$\  $$ | $$| $$ | $$ | $$
| $$ \$$$$| $$$$$$$$| $$__/ $$   \$$ $$  | $$| $$ | $$ | $$
| $$  \$$$ \$$     \ \$$    $$    \$$$$  | $$| $$ | $$ | $$
 \$$   \$$  \$$$$$$$  \$$$$$$      \$`$\  \$$ \$$  \$$  \$$
                      \$                       
                       $)                      
                      ($`                      
                       $_                      
                    ,--" l_                    
                    ;|    )l                   
                    :    _/                    
                    ;   : l`.                  
           .sssss._ L_..; :  \.sSSSSSSs.       
        _.SS$$$$$SSSSSSS   ; `^T$$$$$$$SS.     
      .dSS$$$$$$$$$$$$$$   :   :$$$SS$$$$Sb    
     dSS$$P^^T$$$S$$$$$; _, ;  :$$$$$S$$$$Sb   
    dS$S$P   :$$$S$$S$$-"   :   T$$$$$S$$S$S;  
   dS$$$$   d$$$SS^S$$;     :    T$$$$$S$$SSS  
  dSP^/ ; ;:T$SSP: :$$$     ;_.   T$$$$S$$$SS; 
 dS'   : / :(S^" ; $$SS;   :/`.    T$$$$S$$$SS 
:S     ;    \;  / d$S$P:   ; / \    `T$$S$$$$S;
S$    : .-   ; : :SSSP  \_/.'   \     `^S$$$$SS
:Sb   ;/     : ; $$$P`-   /      j       `T$$S;
 S$bp.:      ; ; $P'   \_g,     dT; ;      j$S 
 :S$S$$j    /  : :    ,-dP-'"--:TT; :     d$S; 
  TS$P' \_.'    \ \  _ s")    d$STT._;_.g$$$S$ 
            bug  \   ;:      :$$$STT$S$$$$$$S$ 
                  \  ;;     /$$$$S$T`TS$$$$$$; 
                   ; ::\__.'/$$$$S^--.T$$$$$$  
                   : ;  -.-'/___       T$$$S;  
                   : :`-. )",--"      ,g$$SP   
                   ; .;__T+'"""-._    $SSS'    
                  :,'     ;       ""--'""      
                  ;  _    :                    
                 :  d"b   d;                   
                 ; $   b d :                   
                 : $ss^" `T;                   
                  \       /                    
                   `.___.'
  ]]

      dashboard_theme.section.header.val = vim.split(logo, '\n')
      dashboard_theme.section.header.opts.hl = 'AlphaHeaderYellow'
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
