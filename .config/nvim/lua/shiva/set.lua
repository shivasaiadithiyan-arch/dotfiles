vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.updatetime = 50

vim.keymap.set('n', '<C-/>', function()
  return vim.v.count == 0 and '<Plug>(comment_toggle_linewise_current)' or '<Plug>(comment_toggle_linewise_count)'
end, { expr = true, desc = "Toggle comment line" })

vim.keymap.set('x', '<C-/>', '<Plug>(comment_toggle_linewise_visual)', { desc = "Toggle comment selection" })
