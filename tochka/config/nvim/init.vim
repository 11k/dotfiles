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

" Disable mouse support.
set mouse=
