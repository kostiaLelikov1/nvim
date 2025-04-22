-- Set leader key
vim.g.mapleader = ' '

-- Setup keymap variable
local keymap = vim.keymap

-- Store all keymaps to be registered when which-key becomes available
local pending_keymaps = {}

-- Create a wrapper for which-key that stores keymaps for later registration
local wk = {
  register = function(mappings, opts)
    -- Handle both old and new format
    if type(mappings[1]) == 'table' then
      -- New format: array of tables with keys, commands, and options
      for _, mapping in ipairs(mappings) do
        local key = mapping[1]
        local cmd = mapping[2]
        local mode = mapping.mode or (opts and opts.mode) or 'n'
        
        -- Skip group definitions
        if cmd ~= nil and mapping.group == nil then
          local mapping_opts = { desc = mapping.desc }
          
          -- Copy other options
          for opt_key, opt_value in pairs(mapping) do
            if opt_key ~= 1 and opt_key ~= 2 and opt_key ~= 'desc' and opt_key ~= 'mode' then
              mapping_opts[opt_key] = opt_value
            end
          end
          
          -- Add options from the parent opts table
          if opts then
            for opt_key, opt_value in pairs(opts) do
              if opt_key ~= 'mode' and mapping_opts[opt_key] == nil then
                mapping_opts[opt_key] = opt_value
              end
            end
          end
          
          keymap.set(mode, key, cmd, mapping_opts)
        end
      end
    else
      -- Old format: dictionary of key -> {command, description}
      for k, v in pairs(mappings) do
        -- Skip group definitions (entries with 'name' field)
        if type(v) == 'table' and v.name == nil then
          -- Extract mode from opts but don't include it in mapping_opts
          local mode = opts and opts.mode or 'n'
          local mapping_opts = { desc = v[2] }
          
          -- Copy other options except mode
          if opts then
            for opt_key, opt_value in pairs(opts) do
              if opt_key ~= 'mode' then
                mapping_opts[opt_key] = opt_value
              end
            end
          end
          
          keymap.set(mode, k, v[1], mapping_opts)
        end
      end
    end
    
    -- Store for later registration with which-key
    table.insert(pending_keymaps, { mappings = mappings, opts = opts })
  end
}

-- Set up an autocmd to register all keymaps with which-key when it's loaded
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = function(event)
    if event.data == "which-key.nvim" then
      -- which-key is now loaded, register all pending keymaps
      local which_key = require('which-key')
      for _, keymap_data in ipairs(pending_keymaps) do
        -- Check if it's the new format (array of tables) or old format (dictionary)
        if type(keymap_data.mappings[1]) == 'table' then
          -- New format - use add()
          which_key.add(keymap_data.mappings, keymap_data.opts)
        else
          -- Old format - use register()
          which_key.register(keymap_data.mappings, keymap_data.opts)
        end
      end
    end
  end,
})

-- Basic keymaps
keymap.set('i', 'jk', '<ESC>', { desc = 'Exit insert mode with jk' })
keymap.set('n', '<leader>nh', ':nohl<CR>', { desc = 'Clear search highlights' })

-- Window navigation with Ctrl keys
wk.register({
  { "<C-h>", ":wincmd h<CR>", desc = "Navigate to left window" },
  { "<C-j>", ":wincmd j<CR>", desc = "Navigate to bottom window" },
  { "<C-k>", ":wincmd k<CR>", desc = "Navigate to top window" },
  { "<C-l>", ":wincmd l<CR>", desc = "Navigate to right window" },
}, { mode = 'n' })

-- Window movement with Alt keys
wk.register({
  { "<A-h>", ":wincmd H<CR>", desc = "Move window left" },
  { "<A-j>", ":wincmd J<CR>", desc = "Move window down" },
  { "<A-k>", ":wincmd K<CR>", desc = "Move window up" },
  { "<A-l>", ":wincmd L<CR>", desc = "Move window right" },
}, { mode = 'n' })

-- Window management
wk.register({
  { "<leader>wq", "<C-w>q", desc = "Close window" },
  { "<leader>ws", "<C-w>s", desc = "Split window horizontally" },
  { "<leader>wv", "<C-w>v", desc = "Split window vertically" },
  { "<leader>w=", "<C-w>=", desc = "Equal window size" },
}, { mode = 'n' })

-- Scrolling with centering
wk.register({
  { "<C-d>", "<C-d>zz", desc = "Scroll down half a page" },
  { "<C-u>", "<C-u>zz", desc = "Scroll up half a page" },
}, { mode = 'n' })

-- Search and replace
wk.register({
  { "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = "Replace word under cursor" },
}, { mode = 'n' })

-- Function to delete hidden buffers
local function delete_hidden_buffers(options)
  local force = options and options.force or false
  local buffers = vim.api.nvim_list_bufs()
  for _, buffer in ipairs(buffers) do
    if vim.fn.buflisted(buffer) and vim.fn.bufwinnr(buffer) == -1 then
      if not force then
        vim.api.nvim_command('bwipeout ' .. buffer)
      else
        vim.api.nvim_command('bwipeout! ' .. buffer)
      end
    end
  end
end

-- Buffer management
wk.register({
  { "<leader>bd", ":bd<CR>", desc = "Delete buffer" },
  { "<leader>bn", ":bnext<CR>", desc = "Next buffer" },
  { "<leader>bp", ":bprevious<CR>", desc = "Previous buffer" },
  { "<leader>ba", delete_hidden_buffers, desc = "Delete all hidden buffers" },
  { "<leader>bA", function() delete_hidden_buffers({ force = true }) end, desc = "Force delete all hidden buffers" },
}, { mode = 'n' })

-- Tab management
wk.register({
  { "<leader>tc", ":tabclose<CR>", desc = "Close tab" },
  { "<leader>tn", ":$tabnew<CR>", desc = "New tab" },
  { "<leader>to", ":tabonly<CR>", desc = "Close all tabs except current" },
  { "<leader>tl", ":tabnext<CR>", desc = "Next tab" },
  { "<leader>th", ":tabprevious<CR>", desc = "Previous tab" },
}, { mode = 'n' })

-- Set up Alt+Number keymaps for quick tab navigation
local tab_keymaps = {}
for i = 1, 9 do
  table.insert(tab_keymaps, { '<A-' .. i .. '>', i .. 'gt', desc = 'Go to tab ' .. i })
end
wk.register(tab_keymaps, { mode = 'n' })
wk.register({
  { "<A-0>", ":tablast<CR>", desc = "Go to last tab" },
}, { mode = 'n' })

-- Additional editor keymaps
wk.register({
  -- Quick save
  { "<leader>ww", ":w<CR>", desc = "Save file" },
  { "<leader>wa", ":wa<CR>", desc = "Save all files" },
  
  -- Quick quit
  { "<leader>qq", ":q<CR>", desc = "Quit" },
  { "<leader>qa", ":qa<CR>", desc = "Quit all" },
  { "<leader>qw", ":wq<CR>", desc = "Save and quit" },
  
  -- Text manipulation
  { "<leader>xd", 'ggVG"_d', desc = "Delete all text" },
  { "<leader>xy", "ggVGy", desc = "Yank all text" },
}, { mode = 'n' })

-- Window resize keymaps
wk.register({
  { "<A-Up>", ":resize -2<CR>", desc = "Decrease window height" },
  { "<A-Down>", ":resize +2<CR>", desc = "Increase window height" },
  { "<A-Left>", ":vertical resize -2<CR>", desc = "Decrease window width" },
  { "<A-Right>", ":vertical resize +2<CR>", desc = "Increase window width" },
}, { mode = 'n', remap = false, silent = true })

-- Miscellaneous keymaps
wk.register({
  -- Help and documentation
  { "<leader>h", ":WhichKey<CR>", desc = "Show keybinding help" },
}, { mode = 'n' })

-- Terminal keymaps
wk.register({
  { "<leader>Tt", ":terminal<CR>", desc = "Open terminal" },
  { "<leader>Tv", ":vsplit | terminal<CR>", desc = "Open terminal in vertical split" },
  { "<leader>Ts", ":split | terminal<CR>", desc = "Open terminal in horizontal split" },
}, { mode = 'n' })

-- Escape terminal mode with Escape key
wk.register({
  { "<Esc>", "<C-\\><C-n>", desc = "Exit terminal mode", mode = "t" },
})

-- Additional window management keymaps
wk.register({
  { "<leader>wm", ":resize | vertical resize<CR>", desc = "Maximize current window" },
  { "<leader>we", ":wincmd =<CR>", desc = "Equal window sizes" },
}, { mode = 'n', remap = false, silent = true })
