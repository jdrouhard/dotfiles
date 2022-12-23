local M = {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    'rcarriga/nvim-notify',
    'nvim-lua/plenary.nvim',
    'fannheyward/telescope-coc.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
  }
}

function M.config()
  local actions = require('telescope.actions')
  local mappings = {
    ["<c-k>"] = actions.move_selection_previous,
    ["<c-j>"] = actions.move_selection_next,
    ["<c-b>"] = actions.preview_scrolling_up,
    ["<c-f>"] = actions.preview_scrolling_down,
  }

  require('telescope').setup {
    defaults = {
      mappings = {
        i = mappings,
        n = mappings,
      },
      winblend = 10,
      layout_strategy = 'flex',
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = 'smart_case',
      },
      coc = {
        prefer_locations = true
      },
    },
    pickers = {
      grep_string = {
        use_regex = true,
      },
      buffers = {
        sort_lastused = true,
        --previewer = false,
      }
    }
  }

  require('telescope').load_extension('fzf')
  require('telescope').load_extension('coc')
  require('telescope').load_extension('notify')
end

function M.init()
  -- disable automatic Telescope mappings in favor of fzf-lua
  if not require('globals').telescope then
    return
  end

  local map = vim.keymap.set
  local function grep()
    vim.ui.input({ prompt = "Grep For > " }, function(term)
      if not term or term == '' then
        return
      end
      return require('telescope.builtin').grep_string({ search = term })
    end)
  end

  map('n', '<leader>s', grep)
  map('n', '<leader>ag', function() require('telescope.builtin').grep_string() end)
  map('n', '<leader>rg', function() require('telescope.builtin').live_grep() end)

  map('n', '<c-p>', function() require('telescope.builtin').find_files() end)
  map('n', '<leader>l', function() require('telescope.builtin').buffers() end)
  map('n', '<leader>h', function() require('telescope.builtin').commands() end)
  map('n', '<leader>?', function() require('telescope.builtin').help_tags() end)
  map('n', '<leader>gs', function() require('telescope.builtin').git_status() end)
  map('n', '<leader>gl', function() require('telescope.builtin').git_commits() end)
  map('n', '<leader>gbl', function() require('telescope.builtin').git_bcommits() end)
  map('n', '<leader>gf', function() require('telescope.builtin').git_files() end)
  map('n', '<leader>qf', function() require('telescope.builtin').quickfix() end)

  map('n', 'gr', '<cmd>Telescope coc references<CR>')
end

return M
