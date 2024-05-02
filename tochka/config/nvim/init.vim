" List plugins to install via vim-plug with `:PlugInstall`.
call plug#begin()
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'tpope/vim-vinegar'
Plug 'itchyny/lightline.vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
Plug 'prettier/vim-prettier'
call plug#end()

" Use hybrid line numbers.
:set number relativenumber
:set nu rnu

" Set highlight color.
:let highlightColor = '#3a3a3a'

" Highlight current line and set highlight colors.
set cursorline
:hi CursorLine cterm=none ctermbg=235 guibg=highlightColor
:hi CursorColumn cterm=none ctermbg=235 guibg=highlightColor
:hi CursorLineNr cterm=none ctermfg=250 ctermbg=235 guibg=highlightColor

" Draw a line down 81st column.
set colorcolumn=81
:hi ColorColumn cterm=none ctermbg=235 guibg=highlightColor

" Tab stops every two columns.
set tabstop=4

" Shift lines by two columns when using reindent operations.
set shiftwidth=4

" Expand tabs to spaces.
set expandtab

" All searches are case insensitive except when searching for something with an
" uppercase character.
set ignorecase
set smartcase

" Use UTF-8 encoding.
set encoding=utf-8
set fileencoding=utf-8

" Use system clipboard for yanks in both macOS and Linux.
" https://stackoverflow.com/a/30691754
set clipboard=unnamed,unnamedplus

" Reload a file when it changes on disk.
set autoread
autocmd FocusGained * :checktime

" Disable mouse support.
set mouse=

" Configure Telescope picker shortcuts.
:nnoremap <C-p> :lua require'telescope.builtin'.find_files{}<Enter>
:nnoremap <C-F> :lua require'telescope.builtin'.live_grep{}<Enter>

" Set theme.
:colorscheme catppuccin_frappe

" Configure lightline.
set noshowmode
let g:lightline = { 'colorscheme': 'catppuccin_frappe' }

" Configure Tree-sitter.
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  auto_install = false,
}
EOF

" Configure LSP.
lua <<EOF
require'lspconfig'.psalm.setup{
    cmd = { "vendor/bin/psalm-language-server", "--use-baseline=baseline.xml", "--show-diagnostic-warnings=false" },
}
require'lspconfig'.tsserver.setup{
    cmd = { "npx", "typescript-language-server", "--stdio" },
}
EOF

" https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#phpactor
lua <<EOF
require'lspconfig'.phpactor.setup{}
EOF

lua <<EOF
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
EOF

" Configure formatters.
" Ensure vim-prettier's default tab width matches prettier's default tab
" width.
let g:prettier#config#tab_width = 2
let g:prettier#config#trailing_comma = 'all'

augroup prettier
    autocmd!
    autocmd BufWritePre *.js,*.ts,*.json,*.html.twig,*.html,*.jsx,*.tsx,*.css,*.scss,*.php PrettierAsync
augroup END
