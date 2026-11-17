vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.mouse = 'a'
opt.showmode = false
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.cursorline = true
opt.scrolloff = 10
opt.confirm = true
opt.clipboard = 'unnamedplus'
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.inccommand = 'split'

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'File explorer' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper window' })

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
}

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yank',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
  if vim.v.shell_error ~= 0 then error('Failed installing lazy.nvim:\n' .. out) end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  { 'tpope/vim-fugitive' },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- Required to read Markdown syntax
      'echasnovski/mini.icons', -- Optional: adds clean icons
    },
    ft = { 'markdown' }, -- Only loads when you open a .md file
    opts = {}, -- Uses default settings; you can add options here later
  },

  { 'tpope/vim-rhubarb' },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'
        local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end

        -- Navigation: fall through to vim's own ]c/[c inside a diff split.
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, 'Next git change')
        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, 'Previous git change')

        -- Hunk actions live under <leader>g to match the which-key 'Git' group.
        map('v', '<leader>gs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Stage selection')
        map('v', '<leader>gr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Reset selection')
        map('n', '<leader>gs', gitsigns.stage_hunk, 'Stage hunk')
        map('n', '<leader>gr', gitsigns.reset_hunk, 'Reset hunk')
        map('n', '<leader>gS', gitsigns.stage_buffer, 'Stage buffer')
        map('n', '<leader>gR', gitsigns.reset_buffer, 'Reset buffer')
        map('n', '<leader>gp', gitsigns.preview_hunk, 'Preview hunk')
        map('n', '<leader>gi', gitsigns.preview_hunk_inline, 'Preview hunk inline')
        map('n', '<leader>gb', function() gitsigns.blame_line { full = true } end, 'Blame line')
        map('n', '<leader>gd', gitsigns.diffthis, 'Diff against index')
        map('n', '<leader>gD', function() gitsigns.diffthis '@' end, 'Diff against last commit')
        map('n', '<leader>gq', gitsigns.setqflist, 'Hunks to quickfix (buffer)')
        map('n', '<leader>gQ', function() gitsigns.setqflist 'all' end, 'Hunks to quickfix (repo)')

        -- Toggles join the existing <leader>t group.
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, 'Toggle line blame')
        map('n', '<leader>tw', gitsigns.toggle_word_diff, 'Toggle word diff')
        map('n', '<leader>td', gitsigns.toggle_deleted, 'Toggle deleted lines')

        -- Text object: operate on a hunk, e.g. `dih` to discard it.
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'Select git hunk')
      end,
    },
  },

  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        style = 'night',
        -- Paint an opaque background rather than letting ghostty's
        -- background-opacity show the wallpaper through the editor.
        transparent = false,
        -- True black everywhere instead of tokyonight's navy #1a1b26.
        on_colors = function(c)
          c.bg = '#000000'
          c.bg_dark = '#000000'
          c.bg_dark1 = '#000000'
          c.bg_float = '#000000'
          c.bg_popup = '#000000'
          c.bg_sidebar = '#000000'
          c.bg_statusline = '#000000'
        end,
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  { 'echasnovski/mini.icons', opts = {} },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'echasnovski/mini.icons' },
    opts = {},
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'modern',
      delay = 300,
      plugins = { spelling = true },
      spec = {
        { '<leader>s', group = 'Search' },
        { '<leader>g', group = 'Git' },
        { '<leader>t', group = 'Toggle' },
        { '<leader>d', group = 'Debug' },
        { '<leader>x', group = 'Diagnostics' },
      },
    },
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'echasnovski/mini.icons',
    },
    keys = {
      { '<leader>e', '<cmd>Neotree toggle<CR>', desc = 'Toggle explorer' },
      { '\\', '<cmd>Neotree reveal<CR>', desc = 'Reveal current file in explorer', silent = true },
    },
    opts = {
      filesystem = {
        -- `\` reveals the current file; pressing it again inside the tree closes it.
        window = { mappings = { ['\\'] = 'close_window' } },
      },
    },
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
    },
  },

  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<CR>', desc = 'Quickfix (Trouble)' },
      { '<leader>xs', '<cmd>Trouble symbols toggle<CR>', desc = 'Symbols (Trouble)' },
    },
  },

  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {},
  },

  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
      local telescope = require 'telescope'
      telescope.setup {
        extensions = {
          ['ui-select'] = require('telescope.themes').get_dropdown(),
        },
      }
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      local map = vim.keymap.set
      map('n', '<leader>sh', builtin.help_tags, { desc = 'Help' })
      map('n', '<leader>sk', builtin.keymaps, { desc = 'Keymaps' })
      map('n', '<leader>sf', builtin.find_files, { desc = 'Files' })
      map('n', '<leader>ss', builtin.builtin, { desc = 'Telescope' })

      vim.keymap.set('n', '<C-/>', function() require('Comment.api').toggle.linewise.current() end, { desc = 'Toggle comment' })
      vim.keymap.set('n', '<C-_>', function() require('Comment.api').toggle.linewise.current() end, { desc = 'Toggle comment' })

      vim.keymap.set('v', '<C-/>', "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = 'Toggle comment selection' })
      vim.keymap.set('v', '<C-_>', "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = 'Toggle comment selection' })
      map({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = 'Current word' })
      map('n', '<leader>sg', builtin.live_grep, { desc = 'Live grep' })
      map('n', '<leader>sd', builtin.diagnostics, { desc = 'Diagnostics' })
      map('n', '<leader>sr', builtin.resume, { desc = 'Resume' })
      map('n', '<leader>s.', builtin.oldfiles, { desc = 'Recent files' })
      map('n', '<leader>sc', builtin.commands, { desc = 'Commands' })
      map('n', '<leader><leader>', builtin.buffers, { desc = 'Buffers' })
      map(
        'n',
        '<leader>/',
        function()
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        { desc = 'Search in current buffer' }
      )
      map(
        'n',
        '<leader>s/',
        function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        { desc = 'Search in open files' }
      )
      map('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true } end, { desc = 'Neovim files' })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local parsers = {
        'bash',
        'c',
        'go',
        'lua',
        'python',
        'java',
        'javascript',
        'typescript',
        'html',
        'markdown',
        'vim',
        'vimdoc',
      }
      require('nvim-treesitter').install(parsers)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      cmp.setup {
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<Tab>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete(),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        },
      }
    end,
  },

  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'gofumpt', 'goimports' },
        python = { 'black' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc) vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc }) end
          local builtin = require 'telescope.builtin'
          map('gd', builtin.lsp_definitions, 'Go definition')
          map('gr', builtin.lsp_references, 'References')
          map('gI', builtin.lsp_implementations, 'Implementation')
          map('<leader>D', builtin.lsp_type_definitions, 'Type definition')
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
          map('K', vim.lsp.buf.hover, 'Hover')
          map('gD', vim.lsp.buf.declaration, 'Declaration')
          map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, 'Toggle inlay hints')
        end,
      })

      require('mason').setup()
      require('mason-tool-installer').setup {
        ensure_installed = {
          'gofumpt',
          'goimports',
          'stylua',
          'black',
          'prettier',
        },
      }

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = { unusedparams = true },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        jdtls = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'workspace',
              },
            },
          },
        },
        ts_ls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server)
            local config = servers[server] or {}
            config.capabilities = capabilities
            require('lspconfig')[server].setup(config)
          end,
        },
      }
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      indent = { char = '│' },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = {
        filetypes = { 'help', 'lazy', 'mason', 'neo-tree', 'trouble', 'dapui_scopes', 'dapui_watches' },
      },
    },
  },

  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufWritePost', 'InsertLeave' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        python = { 'ruff' },
        sh = { 'shellcheck' },
        bash = { 'shellcheck' },
      }

      -- Nothing above is auto-installed, so only run a linter whose binary is
      -- actually on PATH (mason's bin dir included). Missing tools are skipped
      -- silently instead of erroring on every write.
      local function available(names)
        local runnable = {}
        for _, name in ipairs(names or {}) do
          local linter = lint.linters[name]
          local cmd = type(linter) == 'table' and linter.cmd or name
          if vim.fn.executable(cmd) == 1 then table.insert(runnable, name) end
        end
        return runnable
      end

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('lint', { clear = true }),
        callback = function()
          -- Skip unmodifiable buffers so LSP hover popups don't get linted.
          if not vim.bo.modifiable then return end
          local runnable = available(lint.linters_by_ft[vim.bo.filetype])
          if #runnable > 0 then lint.try_lint(runnable) end
        end,
      })

      vim.keymap.set('n', '<leader>tl', function()
        local runnable = available(lint.linters_by_ft[vim.bo.filetype])
        if #runnable == 0 then
          vim.notify('No linter installed for ' .. vim.bo.filetype, vim.log.levels.WARN)
        else
          lint.try_lint(runnable)
        end
      end, { desc = 'Lint current buffer' })
    end,
  },

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'leoluz/nvim-dap-go',
      'mfussenegger/nvim-dap-python',
    },
    -- Keys live under <leader>d: the F-keys kickstart suggests are already
    -- taken by the per-language run/test/build maps in after/ftplugin/.
    keys = {
      { '<leader>dc', function() require('dap').continue() end, desc = 'Start/continue' },
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle breakpoint' },
      { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Conditional breakpoint' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'Step into' },
      { '<leader>do', function() require('dap').step_over() end, desc = 'Step over' },
      { '<leader>dO', function() require('dap').step_out() end, desc = 'Step out' },
      { '<leader>dt', function() require('dap').terminate() end, desc = 'Terminate' },
      { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle debug UI' },
      { '<leader>dr', function() require('dap').run_last() end, desc = 'Re-run last' },
      { '<leader>dR', function() require('dap').repl.toggle() end, desc = 'Toggle REPL' },
      { '<leader>dh', function() require('dap.ui.widgets').hover() end, mode = { 'n', 'v' }, desc = 'Inspect value under cursor' },
      {
        '<leader>dT',
        function()
          local ft = vim.bo.filetype
          if ft == 'go' then
            require('dap-go').debug_test()
          elseif ft == 'python' then
            require('dap-python').test_method()
          else
            vim.notify('No test debugger for filetype: ' .. ft, vim.log.levels.WARN)
          end
        end,
        desc = 'Debug nearest test',
      },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        automatic_installation = true,
        -- delve debugs Go, debugpy debugs Python.
        ensure_installed = { 'delve', 'debugpy' },
        handlers = {},
      }

      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      require('dap-go').setup {
        delve = { detached = vim.fn.has 'win32' == 0 },
      }

      -- Point dap-python at mason's debugpy venv rather than the system
      -- python, so it works regardless of which venv the project uses.
      local debugpy = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
      require('dap-python').setup(vim.uv.fs_stat(debugpy) and debugpy or 'python3')

      -- Breakpoint signs: red dot for a breakpoint, arrow for the stopped line.
      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
      for name, icon in pairs { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '▶' } do
        local hl = (name == 'Stopped') and 'DapStop' or 'DapBreak'
        vim.fn.sign_define('Dap' .. name, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  {
    'mbbill/undotree',
    cmd = { 'UndotreeToggle', 'UndotreeShow', 'UndotreeFocus' },
    keys = {
      { '<leader>u', '<cmd>UndotreeToggle<CR>', desc = 'Toggle undo tree' },
    },
    -- Vimscript plugin: these globals must be set before it loads.
    init = function()
      vim.g.undotree_WindowLayout = 2 -- tree on the left, diff below it
      vim.g.undotree_SplitWidth = 34
      vim.g.undotree_DiffpanelHeight = 12
      vim.g.undotree_SetFocusWhenToggle = 1 -- jump into the panel on open
      vim.g.undotree_ShortIndicators = 1 -- "2h" instead of "2 hours ago"
    end,
  },
}
