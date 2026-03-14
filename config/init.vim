
  " Indicate which plugins to install
  call plug#begin('~/.local/share/nvim/plugged')

  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " This is the old command to set up fzf, but it worked well on linux
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  " This is the new one, might have been a fluke but did not work
  " Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  " For help - :help fzf
  Plug 'junegunn/fzf.vim'

  " Get Copilot setup
  Plug 'github/copilot.vim'
  Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'do': 'make tiktoken' }
  " help :CopilotChat
  " help copilot  - also gets you the help docs
  Plug 'nvim-lua/plenary.nvim'  " Dependency for chat

  " LSP + Mason
  " Mason is a language server package manager,
  " LSP is the Language Server Protocol to standardize
  " language server communication
  " Open mason interface with :Mason
  " Install with :MasonInstall serverName
  " Check servers with :LspInfo
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'

  " Completion
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'

  Plug 'Vimjas/vim-python-pep8-indent'

  " For markdown syntax highlight
  Plug 'tpope/vim-markdown'

  " Color scheme
  Plug 'sainnhe/sonokai'

  call plug#end()
  " :PlugInstall       to install all
  " :PlugUpdate        Update them
  " :PlugStatus        Check status, shows if they installed right

  " set the leader for custom commands.
  let mapleader = "\<Space>" " retain the default, space bar.

  " Syntax highlight stuff
  " Important!!
  if has('termguicolors')
    set termguicolors
  endif
  " Colorshceme config - optional, checkout https://github.com/sainnhe/sonokai/blob/master/doc/sonokai.txt
  " let g:sonokai_style = 'Maia'
  " then activate it
  colorscheme sonokai

  " Copilot settings
  imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
  " let g:copilot_no_tab_map = v:false  " Enable Tab override

  " line numbers
  set number
  " Allow hidden buffers, and more than one file in a split
  set hidden
  " Make backspace work in a sane way even if you won't use it.
  set backspace=indent,eol,start
  " Have vim read changes when they are made to a file
  set autoread

  :filetype on
  autocmd FileType python setlocal expandtab smartindent ts=4 sw=4 textwidth=0 fileformat=unix
  autocmd FileType javascript setlocal expandtab smartindent ts=4 sw=4 sts=4
  autocmd FileType javascriptreact setlocal expandtab smartindent ts=4 sw=4 sts=4
  autocmd FileType typescript setlocal expandtab smartindent ts=4 sw=4 sts=4
  autocmd FileType typescriptreact setlocal expandtab smartindent ts=4 sw=4 sts=4
  autocmd FileType html setlocal expandtab smartindent ts=2 sw=2 sts=2
  autocmd FileType css setlocal expandtab smartindent ts=4 sw=4 sts=4
  autocmd FileType json setlocal expandtab smartindent ts=4 sw=4 sts=4


  " A remap of escape so that exiting edit can be done without Ctrl-C
  " apparently Ctrl-C can cause lots of problems.
  inoremap jj <Esc>

  " Easier copy to and paste from system clipboard.
  nnoremap <leader>p "+p
  nnoremap <leader>y "+y
  vnoremap <leader>y "+y
  vnoremap <leader>p "+p

  " To find more options, :h fzf-vim-commands
  " Fuzzy search all file names
  nnoremap <leader>fa :Files<cr>
  " Fuzzy search all file names under git tracking
  nnoremap <leader>fg :GFiles<cr>
  " Fuzzy search buffer names
  nnoremap <leader>fb :Buffers <cr>
  " Fzf and Ripgrep to grep search both name and contents
  nnoremap <leader>fn :Rg <cr>
  " Find in lines of buffers currently open
  nnoremap <leader>fl :Lines <cr>
  " Find in Command History
  nnoremap <leader>fh :History: <cr>
  " Find in Search History
  nnoremap <leader>fs :History/ <cr>


" Now load Lua configuration AFTER plugins are defined
lua << EOF
-- Mason setup
require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "ts_ls", "html", "cssls", "jsonls" },
  automatic_installation = true,
})

-- Setup LSP servers
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Python
vim.lsp.config.pyright = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
  default_config = {
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
        },
      },
    },
  },
}

-- TypeScript/JavaScript
vim.lsp.config.ts_ls = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  default_config = {
    capabilities = capabilities,
  },
}

-- HTML
vim.lsp.config.html = {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  root_markers = { ".git" },
  default_config = {
    capabilities = capabilities,
  },
}

-- CSS
vim.lsp.config.cssls = {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_markers = { ".git" },
  default_config = {
    capabilities = capabilities,
  },
}

-- JSON
vim.lsp.config.jsonls = {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { ".git" },
  default_config = {
    capabilities = capabilities,
  },
}

-- Enable the LSP servers on the appropriate filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "javascript", "javascriptreact", "typescript", "typescriptreact", "html", "css", "scss", "less", "json", "jsonc" },
  callback = function()
    vim.lsp.enable(vim.bo.filetype)
  end,
})


-- Completion setup (nvim-cmp)
local cmp = require('cmp')

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- LSP Keybindings
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf, noremap = true, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
  end,
})

-- Show diagnostics on cursor hold
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end
})

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Treesitter setup
require('nvim-treesitter.configs').setup({
  ensure_installed = { "python", "javascript", "typescript", "tsx", "html", "css", "json", "lua", "bash", "markdown" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- CopilotChat Setup
require("CopilotChat").setup({
  window = { layout = 'float', width = 0.3 },  -- Compact chat window
})
EOF
