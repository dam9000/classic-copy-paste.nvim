-- Classic Copy & Paste

--[[

- Ctrl-Del          = Delete (without copying to clipboard)
- Shift-Del         = Cut
- Ctrl-Insert       = Copy
- Shift-Insert      = Paste
- Mouse selection   = Copy to X11 primary selection

vim modes:
  'n' = normal
  'i' = insert
  'c' = command
  'v' = visual
  ''  = 'n' + 'v' + 'o'

vim registers:
  "" = unnamed register - used by 'd', 'y', 'p',...
  "* = X11 primary selection (mouse selection)
  "+ = X11 clipboard (ctrl-c or ctrl-insert)
  "_ = black hole register

--]]

local M = {}

M.orig_vim_paste = nil

function M.insert_paste()
  vim.api.nvim_paste(vim.fn.getreg('+'), false, -1)
end

function M.vim_paste_handler(lines, phase)
  if vim.fn.mode() == 'c' then
    -- nvim_put can't be used in command mode
    -- as the text is then pasted in buffer
    M.orig_vim_paste(lines, phase)
  else
    --[[
    api: nvim_put({lines}, {type}, {after}, {follow})
    Puts text at cursor, in any mode.
    • {after} If true insert after cursor (like p), or before (like P).
    --]]
    vim.api.nvim_put(lines, 'c', false, true)
  end
end

function M.setup(opts)

  vim.g.loaded_classic_copy_paste = 1

  -- mouse selection to x11 primary cliboard
  -- single click - covers click+drag
  vim.keymap.set('v', '<LeftRelease>', '"*ygv')
  -- double click - selects word
  vim.keymap.set('v', '<2-LeftRelease>', '"*ygv')
  vim.keymap.set('i', '<2-LeftRelease>', '<c-o>"*y<c-o>gv')
  -- triple click - selects line
  vim.keymap.set('v', '<3-LeftRelease>', '"*ygv')

  -- Shift-Del    = Cut
  vim.keymap.set('v', '<S-Del>', '"+x', { desc='Cut' })

  -- Ctrl-Del     = Delete without copying (black hole register)
  vim.keymap.set('v', '<C-Del>', '"_x', { desc='Clear' })

  -- Ctrl-Insert  = Copy
  vim.keymap.set('v', '<C-Insert>', '"+y', { desc='Copy' })

  -- Shift-Insert = Paste
  -- normal mode
  vim.keymap.set('', '<S-Insert>', '"+gP', { desc='Paste' })

  -- insert mode
  --[[
  Paste in insert mode is tricky, options:

  vim.keymap.set('i', '<S-Insert>', '<C-R>+')
  * insert mode <C-R>+ reformats text, not good
  * however it works in telescope
  * and properly pastes after end of line

  vim.keymap.set('i', '<S-Insert>', '<C-o>"+gP')
  * insert mode "+gP does not work in telesope
  * also does not work well after end of line
  * but properly pastes without autoindent reformatting

  using api.nvim_paste works properly in all cases
  * properly pastes without autoindent reformatting
  * properly pastes after end of line
  * properly pastes in telescope picker input line

  api: nvim_paste({data}, {crlf}, {phase})
  Pastes at cursor, in any mode
  phase -1: paste in a single call
  --]]
  vim.keymap.set('i', '<S-Insert>', M.insert_paste, { desc='Paste' })

  -- terminal mode bracketed paste handler
  if not M.orig_vim_paste then
    M.orig_vim_paste = vim.paste
  end
  vim.paste = M.vim_paste_handler

  -- command mode paste
  --[[
  <C-R>+ pastes the text as if typed which will reformat it,
  not suitable for insert mode but it is ok for command mode
  --]]
  vim.keymap.set('c', '<S-Insert>', '<C-R>+', { desc='Paste' })

  -- ctrl-insert, shift-insert likely can't be intercepted in terminal mode
  -- as an alternative assign alt-c, alt-v
  if opts and (opts.alt_cv == false) then
    -- skip
  else
    -- alt-c - Copy
    vim.keymap.set('v', '<M-c>', '"+y', { desc='Copy' })
    -- alt-v - Paste
    vim.keymap.set('',  '<M-v>', '"+gP', { desc='Paste' })
    vim.keymap.set('i', '<M-v>', M.insert_paste, { desc='Paste' })
    vim.keymap.set('c', '<M-v>', '<C-R>+', { desc='Paste' })
  end

end

return M

-- vim: ts=2 sts=2 sw=2 et
