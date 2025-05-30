-- ftplugin/yaml.lua
-- Automatische Kubernetes Schema-Erkennung für YAML-Dateien
--

-- Verhindere mehrfache Ausführung für denselben Buffer
if vim.b.yaml_k8s_loaded then
  return
end
vim.b.yaml_k8s_loaded = true

print 'enter'
-- Funktion zur Prüfung auf Kubernetes apiVersion
local function has_kubernetes_api_version(lines)
  -- Kubernetes API-Versionen Pattern
  local k8s_api_versions = {
    'v1',
    'apps/v1',
    'batch/v1',
    'autoscaling/v1',
    'autoscaling/v2',
    'rbac.authorization.k8s.io/v1',
    'networking.k8s.io/v1',
    'policy/v1',
    'coordination.k8s.io/v1',
    'storage.k8s.io/v1',
    'authentication.k8s.io/v1',
    'authorization.k8s.io/v1',
    'apiextensions.k8s.io/v1',
    'admissionregistration.k8s.io/v1',
    'events%.k8s.io/v1',
  }
  for i, line in ipairs(lines) do
    if i > 40 then
      return false
    end
    for _, api_version in ipairs(k8s_api_versions) do
      -- escape dots with '%.' in k8s api version string
      local escaped = api_version:gsub('([%.])', '%%%1')
      -- create pattern for api version
      local pattern = '^apiVersion:' .. '%s*' .. escaped .. '%s*'
      if line:match(pattern) then
        return true
      end
    end
  end
  return false
end

-- Funktion zum Setzen des Kubernetes Schemas
local function set_kubernetes_schema(enable_k8s)
  local clients = vim.lsp.get_clients { name = 'yamlls' }
  if not clients or #clients == 0 then
    return
  end

  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == '' then
    return
  end

  local k8s_settings
  if enable_k8s then
    k8s_settings = {
      yaml = {
        schemas = {
          kubernetes = current_file,
        },
      },
    }
    vim.b.kubernetes_schema_enabled = true
  else
    k8s_settings = {
      yaml = {
        schemas = {
          kubernetes = '',
        },
      },
    }
    vim.b.kubernetes_schema_enabled = false
  end

  for _, client in ipairs(clients) do
    local new_settings = vim.tbl_deep_extend('force', client.settings, k8s_settings)
    client.settings = new_settings
    local is_successful = client.notify('workspace/didChangeConfiguration', { settings = new_settings })
    local new_clients = vim.lsp.get_clients { name = 'yamlls' }
    if not is_successful then
      vim.notify 'Error when notifying yamlls to add schema'
    end
  end
end

-- set autocommand for detecting gitlab-ci files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.gitlab-ci*.{yml,yaml}',
  callback = function()
    vim.bo.filetype = 'yaml.gitlab'
  end,
})

-- Funktion zur Schema-Erkennung und -Aktivierung
local function check_and_set_kubernetes_schema()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  if has_kubernetes_api_version(lines) then
    set_kubernetes_schema(true)
    -- vim.notify('Kubernetes Schema aktiviert für ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
  else
    set_kubernetes_schema(false)
  end
end

-- Initiale Prüfung beim Laden des Buffers
check_and_set_kubernetes_schema()

-- Autocommands für diesen Buffer
local group = vim.api.nvim_create_augroup('KubernetesYamlBuffer', { clear = false })

-- Prüfung nach dem Schreiben
vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  buffer = 0,
  callback = check_and_set_kubernetes_schema,
})

-- Manueller Toggle-Befehl für aktuellen Buffer
vim.api.nvim_buf_create_user_command(0, 'KubernetesSchemaToggle', function()
  local current_state = vim.b.kubernetes_schema_enabled or false
  set_kubernetes_schema(not current_state)

  if vim.b.kubernetes_schema_enabled then
    vim.notify 'Kubernetes Schema aktiviert'
  else
    vim.notify 'Standard YAML Schema aktiviert'
  end
end, {
  desc = 'Toggle Kubernetes schema for current YAML buffer',
})

-- Buffer-lokale Keymap (optional)
vim.keymap.set('n', '<leader>tk', function()
  vim.cmd 'KubernetesSchemaToggle'
end, {
  buffer = 0,
  desc = '[T]oggle [K]ubernetes schema',
})

-- Cleanup beim Verlassen des Buffers
vim.api.nvim_create_autocmd('BufDelete', {
  group = group,
  buffer = 0,
  callback = function()
    vim.b.yaml_k8s_loaded = nil
    vim.b.kubernetes_schema_enabled = nil
  end,
})
