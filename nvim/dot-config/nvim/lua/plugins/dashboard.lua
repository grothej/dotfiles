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
                                     `$/              
           __                        O$               
       _.-"  )                        $'              
    .-"`. .-":        o      ___     ($o              
 .-".-  .'   ;      ,st+.  .' , \    ($               
:_..-+""    :       T   "^T==^;\;;-._ $\              
   """"-,   ;       '    /  `-:-// / )$/              
        :   ;           /   /  :/ / /dP               
        :   :          /   :    )^-:_.l               
        ;    ;        /    ;    `.___, \           .-,
       :     :       :  /  ;.q$$$$$$b   \$$$p,    /  ;
       ;   :  ;      ; :   :$$$$$$$$$b   T$$$$b .'  / 
       ;   ;  :      ;   _.:$$$$$$$$$$    T$$P^"   /l 
       ;.__L_.:   .q$;  :$$$$$$$$$$$$$;_   TP .-" / ; 
       :$$$$$$;.q$$$$$  $$$$$$$$$$$$$$$$b  / /  .' /  
        $$$$$$$$$$$$$;  $$$$$$$$P^" "^Tb$b/   .'  :   
        :$$$$$$$$$$$$;  $$$$P^jp,      `$$_.+'    ;   
        $$$$$$$$$$$$$;  :$$$.d$$;`- _.-d$$ /     :    
        '^T$$$$$P^^"/   :$$$$$$P      d$$;/      ;    
                   :    $$$$$$P"-. .--$$P/      :     
                   ;    $$$$P'( ,    d$$:b     .$     
                   :    :$$P .-dP-'  $^'$$bqqpd$$     
                    `.   "" ' s")  .'  d$$$$$$$$'     
                      \           /;  :$$$$$$$P'      
                    _  "-, ;       '.  T$$$$P'        
                   / "-.'  :    .--.___.`^^'          
                  /      . :  .'                      
                  ),sss.  \  :  bug                   
                 : TP""Tb. ; ;                        
                 ;  Tb  dP   :                        
                 :   TbdP    ;                        
                  \   $P    /                         
                   `-.___.-'

  ]]

      dashboard_theme.section.header.val = vim.split(logo, '\n')
      dashboard_theme.section.header.opts.hl = 'AlphaHeaderGreen'
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
