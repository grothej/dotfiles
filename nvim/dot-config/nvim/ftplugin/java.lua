-- load os specific config data
local os_config = require 'custom.plugins.os-config'

--
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.expand '~/.local/share/nvim/jdtls-workspace/' .. project_name
local installation_path = vim.fn.stdpath 'data' .. '/mason'

local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    'java', -- or '/path/to/java21_or_newer/bin/java'

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. installation_path .. '/packages/jdtls/lombok.jar',
    '-jar',
    installation_path .. '/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.0.v20250331-1702.jar',
    -- eclipse.jdt.ls installation                                           the actual version

    '-configuration',
    installation_path .. '/packages/jdtls/' .. os_config.get_jdtls_config_name(),
    -- eclipse.jdt.ls installation            Depending on your system.

    '-data',
    workspace_dir,
  },

  root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {},
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {},
  },
}
vim.print(require('spring_boot').java_extensions())
vim.list_extend(jdtls_config.bundles, require('spring_boot').java_extensions())
require('jdtls').start_or_attach(config)
