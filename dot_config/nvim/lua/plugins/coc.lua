local M = {
  'neoclide/coc.nvim',
  branch = 'release',
  event = 'BufReadPost',
  cond = function() return not require('globals').native_lsp end,
}

function M.config()
  local map = vim.keymap.set

  function _G.check_back_space()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return (col == 0 or vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s')) and true
  end

  local opts = { expr = true, replace_keycodes = false }
  map('i', '<Tab>', 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<Tab>" : coc#refresh()', opts)
  map('i', '<S-Tab>', 'coc#pum#visible() ? coc#pum#prev(1) : "<C-h>"', opts)
  map('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<C-g>u<CR><c-r>=coc#on_enter()<CR>"', opts)

  map('n', 'gD', '<plug>(coc-declaration)')
  map('n', 'gd', '<plug>(coc-definition)')
  map('n', 'gi', '<plug>(coc-implementation)')
  map('n', 'gr', '<plug>(coc-references)')
  map('n', 'gTD', '<plug>(coc-type-definition)')
  map('n', '<leader>rn', '<plug>(coc-rename)')
  map('n', 'K', "<cmd>call CocActionAsync('definitionHover')<CR>")
  map('n', '<leader>ac', '<plug>(coc-codeaction-cursor)')
  map('n', ']e', '<plug>(coc-diagnostic-next)')
  map('n', '[e', '<plug>(coc-diagnostic-prev)')

  map({ 'x', 'o' }, 'if', '<plug>(coc-funcobj-i)')
  map({ 'x', 'o' }, 'ic', '<plug>(coc-classobj-i)')

  map('x', '<leader>f', '<plug>(coc-format-selected)')
  map('n', '<leader>f', '<plug>(coc-format)')

  local au_group = vim.api.nvim_create_augroup('coc', {})
  vim.api.nvim_create_autocmd('User', {
    group = au_group,
    pattern = 'CocJumpPlaceholder',
    command = [[call CocActionAsync('showSignatureHelp')]]
  })
  vim.api.nvim_create_autocmd('CursorHold', {
    group = au_group,
    command = [[silent call CocActionAsync('highlight')]]
  })
end

return M
