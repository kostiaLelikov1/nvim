-- Performance optimizations for Neovim
local M = {}

-- Apply startup optimizations
M.optimize_startup = function()
  -- Disable unused built-in plugins to improve startup time
  local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit"
  }

  for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
  end

  -- Defer loading of UI components
  vim.opt.lazyredraw = true
  
  -- Optimize syntax highlighting
  vim.opt.synmaxcol = 240
  
  -- Reduce updatetime for better responsiveness
  vim.opt.updatetime = 100
  
  -- Improve scrolling performance
  vim.opt.ttyfast = true
  
  -- Disable swap files for better performance
  vim.opt.swapfile = false
  
  -- Optimize terminal performance
  vim.g.terminal_responsive = false
end

-- Apply runtime optimizations
M.optimize_runtime = function()
  -- Use treesitter for folding if available
  if pcall(require, "nvim-treesitter") then
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim-treesitter#foldexpr()"
  end
  
  -- Set a reasonable history limit
  vim.opt.history = 1000
  
  -- Optimize for modern terminals
  vim.opt.ttimeoutlen = 10
  
  -- Optimize redrawing
  vim.opt.lazyredraw = true
  
  -- Optimize macro execution
  vim.g.macro_performance = true
end

-- Apply all optimizations
M.apply_all = function()
  M.optimize_startup()
  M.optimize_runtime()
end

return M
