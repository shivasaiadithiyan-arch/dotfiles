local opts = { buffer = true, remap = false, desc = "" }

opts.desc = "Run current Python file"
vim.keymap.set("n", "<F5>", function()
    vim.cmd("split | terminal python3 %")
end, opts)

opts.desc = "Run pytest on current file"
vim.keymap.set("n", "<F6>", function()
    vim.cmd("split | terminal pytest %")
end, opts)

opts.desc = "Run python linting check"
vim.keymap.set("n", "<F7>", function()
    vim.cmd("split | terminal ruff check %")
end, opts)
