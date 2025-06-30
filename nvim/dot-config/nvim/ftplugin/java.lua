-- load os specific config data
local os_config = require 'os-config'

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
    vim.fn.glob(installation_path .. '/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
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

  init_options = {
    bundles = {
      vim.fn.glob(installation_path .. '/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar'),
      vim.fn.glob(installation_path .. '/packages/'),
    },
  },
}

-- add spring boot ls bundles
vim.list_extend(config.init_options.bundles, require('spring_boot').java_extensions())
vim.list_extend(config.init_options.bundles, vim.split(vim.fn.glob(installation_path .. '/packages/java-test/extension/server/*.jar'), '\n'))
require('jdtls').start_or_attach(config)
