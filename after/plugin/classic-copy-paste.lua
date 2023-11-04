-- if setup() was not called by the plugin manager then call it now

if vim.g.loaded_classic_copy_paste == 1 then
  return
end
vim.g.loaded_classic_copy_paste = 1

require('classic-copy-paste').setup()

-- vim: ts=2 sts=2 sw=2 et
