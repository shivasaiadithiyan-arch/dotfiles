local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { "gopls", "pyright", "jdtls", "lua_ls"},
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
    },
})

local cmp = require('cmp')

cmp.setup({
    mapping = cmp.mapping.preset.insert({

	    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
	    ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
	    ['<CR>'] = cmp.mapping.confirm({ select = true }),
	    ['<C-Space>'] = cmp.mapping.complete(),
    
})
})
