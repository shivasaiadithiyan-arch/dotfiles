require("shiva.remap")
require("shiva.set")
require("shiva.lazy")
vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

vim.opt.undofile = true
