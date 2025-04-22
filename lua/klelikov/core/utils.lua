-- Utility functions for Neovim configuration
local M = {}

-- Handle deprecated vim.validate function
M.handle_deprecated_validate = function(callback)
  -- Store the original validate function
  local original_validate = vim.validate
  
  -- Replace with a wrapper that handles the new format
  vim.validate = function(args)
    -- Use the new validate function format
    for name, spec in pairs(args) do
      local value, expected_type, optional = unpack(spec)
      original_validate({[name] = {value, expected_type, optional}})
    end
  end
  
  -- Call the callback function with the wrapper in place
  local status, result = pcall(callback)
  
  -- Restore the original validate function
  vim.validate = original_validate
  
  -- Re-throw any errors
  if not status then
    error(result)
  end
  
  -- Return the result of the callback
  return result
end

-- Helper function to safely require a module
M.safe_require = function(module)
  local status, mod = pcall(require, module)
  if not status then
    vim.notify("Error requiring " .. module .. ": " .. mod, vim.log.levels.ERROR)
    return nil
  end
  return mod
end

-- Helper function to check if a plugin is available
M.is_plugin_available = function(plugin_name)
  return packer_plugins and packer_plugins[plugin_name] and packer_plugins[plugin_name].loaded
end

return M
