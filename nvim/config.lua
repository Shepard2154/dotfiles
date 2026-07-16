
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.encoding = "utf-8"       -- Общая кодировка (необязательно, по умолчанию UTF-8)
vim.opt.fileencoding = "utf-8"  -- Кодировка файлов
vim.opt.number = true -- Show line numbers
vim.opt.cursorline = false -- Disable highlight current cursor's line
vim.opt.swapfile = false -- Disable .swp files 
vim.opt.scrolloff = 7 -- Number of lines left visible above/below the cursor when scrolling
vim.opt.tabstop = 4 -- Spaces instead of one tab
vim.opt.softtabstop = 4 -- Spaces instead of one tab
vim.opt.shiftwidth = 4 -- Spaces for auto indent
vim.opt.expandtab = true -- Replace tab with spaces
vim.opt.autoindent = true -- Save indent on new line
vim.opt.fileformat = "unix"
vim.opt.smartindent = true
vim.opt.splitbelow = true -- horizontal split open below and right
vim.opt.splitright = true
vim.g.mapleader = ',' -- Leader key
vim.opt.termguicolors = true -- 24-bit colors
vim.opt.scrolloff = 0

-- Keymaps for programming languages
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
        vim.opt.colorcolumn = '80'
        vim.keymap.set('n', '<C-h>', ':w<CR>:!python3.13 %<CR>', { buffer = true, silent = true })
        vim.keymap.set('i', '<C-h>', '<Esc>:w<CR>:!python3.13 %<CR>', { buffer = true, silent = true })
    end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'c',
    callback = function()
        vim.keymap.set('n', '<C-h>', ':w<CR>:!gcc % -o out; ./out<CR>', { buffer = true, silent = true })
        vim.keymap.set('i', '<C-h>', '<Esc>:w<CR>:!gcc % -o out; ./out<CR>', { buffer = true, silent = true })
    end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = {'sh', 'go'},
    callback = function()
        vim.keymap.set('n', '<C-h>', ':w<CR>:!%<CR>', { buffer = true, silent = true })
        vim.keymap.set('i', '<C-h>', '<Esc>:w<CR>:!%<CR>', { buffer = true, silent = true })
    end
})

-- Common keymaps
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true })
vim.keymap.set('n', ',<Space>', ':nohlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'H', 'gT', { noremap = true }) -- Переключение вкладок
vim.keymap.set('n', 'L', 'gt', { noremap = true })
vim.keymap.set('n', ',f', ':Telescope find_files<CR>', { noremap = true })
vim.keymap.set('n', ',g', ':Telescope live_grep<CR>', { noremap = true })
vim.keymap.set('n', 'gw', ':bp|bd #<CR>', { noremap = true, silent = true })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with all plugins
require("lazy").setup({
  "wbthomason/packer.nvim", -- Keep for compatibility
  {
    'L3MON4D3/LuaSnip',
    config = function()
      local ls = require("luasnip")
      local snip_path = vim.fn.stdpath("config") .. "/snippets"
      pcall(function()
        require("luasnip.loaders.from_lua").lazy_load({ paths = snip_path })
      end)

      vim.keymap.set({"i", "s"}, "<Tab>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })

      vim.keymap.set({"i", "s"}, "<S-Tab>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })
    end
  },
  'nvim-lua/plenary.nvim',
  'neovim/nvim-lspconfig',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'saadparwaiz1/cmp_luasnip',
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      pcall(function()
        require'nvim-treesitter.configs'.setup {
          ensure_installed = { "python", "bash", "markdown", "markdown_inline" },
          highlight = {
            enable = true,
            disable = { "markdown" },
          },
        }
      end)
    end
  },
  'morhetz/gruvbox',
  'ayu-theme/ayu-vim',
  'sainnhe/gruvbox-material',
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      pcall(function()
        vim.cmd([[colorscheme kanagawa-dragon]])
      end)
    end
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        padding = true,
        toggler = {
          line = ',cc',
          block = ',cb',
        },
        opleader = {
          line = ',c',
          block = ',b',
        },
      })
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    config = function()
      pcall(function()
        require('telescope').setup({
          defaults = {
            file_ignore_patterns = {
              "%.pyc$",
              "__pycache__/",
              "%.pyo$",
            },
          },
        })
        require('telescope').load_extension('fzf')
      end)
    end
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    'Pocco81/auto-save.nvim',
    config = function()
      require('auto-save').setup()
    end
  },
  'nvimtools/none-ls.nvim',
  { 'kaarmu/typst.vim', ft = {'typst'} },
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        keymaps = {
          ["t"] = {
            "actions.select",
            opts = { tab = true },
          },
        },
      })
    end
  },
  {
    "echasnovski/mini.surround",
    config = function()
      require("mini.surround").setup()
    end
  },
})

-- Fallback colorscheme if kanagawa fails
pcall(function()
  vim.cmd([[colorscheme kanagawa-dragon]])
end)

-- LSP Configuration
local lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if lsp_ok then
  local capabilities = cmp_nvim_lsp.default_capabilities()
  local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end

  -- LSP servers setup
  pcall(function()
    vim.lsp.config("pyright", {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
          },
        },
      },
    })
    vim.lsp.enable("pyright")
  end)

  pcall(function()
    vim.lsp.config("ts_ls", {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    vim.lsp.enable("ts_ls")
  end)

  pcall(function()
    vim.lsp.config("gopls", {
      cmd = { "gopls" },
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        gopls = {
          analyses = { unusedparams = true },
          staticcheck = true,
        },
      },
    })
    vim.lsp.enable("gopls")
  end)

  pcall(function()
    vim.lsp.config("rust_analyzer", {
      cmd = { "rust-analyzer" },
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          procMacro = { enable = true },
        },
      },
    })
    vim.lsp.enable("rust_analyzer")
  end)
end

-- Null-ls
pcall(function()
  require('null-ls').setup({
    sources = {
      require('null-ls').builtins.formatting.prettier,
    }
  })
end)

-- Autocomplete
pcall(function()
  local cmp = require('cmp')
  cmp.setup({
    completion = {
      autocomplete = false,
    },
    mapping = {
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }),
  })
end)

-- Transparent background
vim.cmd([[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE
]])

-- LuaSnip config
pcall(function()
  require("luasnip").config.set_config {
    history = true,
    updateevents = "TextChanged,TextChangedI"
  }
end)

-- Clipboard for Windows
vim.g.clipboard = {
  name = 'win32yank',
  copy = {
    ['+'] = 'win32yank.exe -i',
    ['*'] = 'win32yank.exe -i',
  },
  paste = {
    ['+'] = 'powershell -noprofile -command "Get-Clipboard"',
    ['*'] = 'powershell -noprofile -command "Get-Clipboard"',
  },
  cache_enabled = 0,
}

-- Markdown settings
vim.g.markdown_fenced_languages = {
  "python",
  "bash=sh",
  "shell=sh",
}

-- Выделение текста между двумя блоками ``` ... ```
local function set_triple_backtick_region()
  local start_line = vim.fn.search("```", "bW")
  if start_line == 0 then
    return
  end

  local end_line = vim.fn.search("```", "W")
  if end_line == 0 or end_line <= start_line + 1 then
    return
  end

  local inner_start = start_line + 1
  local inner_end = end_line - 1

  vim.fn.setpos("'<", {0, inner_start, 1, 0})
  vim.fn.setpos("'>", {0, inner_end, 999, 0})
end

vim.keymap.set("x", "i`", function()
  set_triple_backtick_region()
  vim.cmd("normal! gv")
end, { noremap = true, silent = true })

vim.keymap.set("o", "i`", function()
  set_triple_backtick_region()
  return "gv"
end, { noremap = true, silent = true, expr = true })

-- jsonl as json files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.jsonl",
  callback = function(args)
    vim.bo[args.buf].filetype = "json"
  end,
})
