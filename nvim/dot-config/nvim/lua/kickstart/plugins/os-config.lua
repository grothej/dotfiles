-- This file contains os specific configs for plugins
-- only differentiates between linux and mac
--

local function get_os()
  if vim.fn.has 'mac' == 1 then
    return 'macos'
  else
    return 'linux'
  end
end

local os = get_os()

local M = {}

M.java = {
  jdtls_config_name = { linux = 'config_linux', macos = 'config_mac_arm' },
}

function M.get_jdtls_config_name()
  return M.java.jdtls_config_name[os]
end

return M
