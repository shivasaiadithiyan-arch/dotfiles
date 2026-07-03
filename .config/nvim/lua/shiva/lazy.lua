-- Tell Neovim where you cloned lazy.nvim
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

require("lazy").setup({
    -- Telescope and its required dependency
    {
        "nvim-telescope/telescope.nvim", 
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    -- Theme
    {
        "catppuccin/nvim", 
        name = "catppuccin", 
        priority = 1000 
    },

    -- File Navigation
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    -- History & Git
    {
        "mbbill/undotree"
    },
    {
        "tpope/vim-fugitive"
    },
    -- LSP & Autocompletion Ecosystem
    {
        "VonHeikemen/lsp-zero.nvim", branch = "v3.x"
    },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
})
