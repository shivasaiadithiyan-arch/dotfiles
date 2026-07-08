local opts = { buffer = true, remap = false, desc = "" }

opts.desc = "Run current Java file"
vim.keymap.set("n", "<F5>", function()
    vim.cmd("split | terminal javac *.java && java %:r")
end, opts)

opts.desc = "Run Spring Boot application"
vim.keymap.set("n", "<F6>", function()
    vim.cmd("split | terminal ./mvnw spring-boot:run")
end, opts)

opts.desc = "Run Maven package"
vim.keymap.set("n", "<F7>", function()
    vim.cmd("split | terminal mvn clean install")
end, opts)
