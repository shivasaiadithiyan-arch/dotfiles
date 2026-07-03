local opts = { buffer = true, remap = false, desc = "" }

opts.desc = "Run current Go file"
vim.keymap.set("n", "<F5>", function()
    vim.cmd("split | terminal go run %")
end, opts)

opts.desc = "Run Go tests"
vim.keymap.set("n", "<F6>", function()
    vim.cmd("split | terminal go test ./...")
end, opts)

opts.desc = "Build Go binary"
vim.keymap.set("n", "<F7>", function()
    vim.cmd("split | terminal go build")
end, opts)
