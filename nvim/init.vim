" Type :so % to refresh .vimrc after making changes

syntax on
set nocompatible
set relativenumber
set cursorline
set encoding=UTF-8
set spell spelllang=en,pl
set mouse=a
set visualbell    " stop that ANNOYING beeping
set wildmenu
set wildmode=list:longest,full

set autoindent
set expandtab
set nofoldenable
set tabstop=4
set shiftwidth=2

let mapleader = " "
let g:netrw_browse_split = 4
let g:netrw_liststyle = 3

" Swap & Backup options DISABLE
set directory=$HOME/.vim/swp//
set nobackup
set nowb
set undofile
set undodir=~/.vim/undodir
set autowrite       " Automatically :write before running commands
set autoread        " Reload files changed outside vim

" Search options
set incsearch       " Find the next match as we type the search. 
set hlsearch        " Highlight searches by default.
set ignorecase      " Ignore case when searching . . .
set smartcase       " . . . unless you type a capital.

" clear the highlighting of `hlsearch`. Stollen from `tpope/vim-sensible`
nnoremap <silent> <leader>, :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" My Zettel prefix keymap
nnoremap <leader>xz "=strftime('%Y%m%d%H%M-')<C-M>p

" vim-plug section
call plug#begin()

    Plug 'tpope/vim-surround'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'kien/ctrlp.vim'

    Plug 'tpope/vim-sensible'
    Plug 'christoomey/vim-tmux-navigator'

    Plug 'rhysd/git-messenger.vim'
    Plug 'lewis6991/gitsigns.nvim'

    Plug 'marko-cerovac/material.nvim'  
    Plug 'hoob3rt/lualine.nvim'

    Plug 'ryanoasis/vim-devicons'

    Plug 'vimwiki/vimwiki'
    Plug 'godlygeek/tabular'
    Plug 'plasticboy/vim-markdown'
call plug#end()

" Another way is clunky dict creation:
" let wiki_list = {}
" let wiki_list.path = '/Users/pnowosie/.vim/wiki' 
let g:vimwiki_list = [{
	\ 'path':   '/Users/pnowosie/.vim/wiki',
	\ 'syntax': 'markdown',
	\ 'ext':    '.md',
	\ 'links_space_char': '-',
	\ }]

let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}

" makes vimwiki links proper format [name](name.ext) instead of [name](name)
let g:vimwiki_markdown_link_ext = 1

" makes sure vimwiki will only set the filetype of markdown files inside a wiki directory, rather than globally.
let g:vimwiki_global_ext = 0


" Per default, netrw leaves unmodified buffers open. This autocommand
" deletes netrw's buffer once it's hidden (using ':q', for example)
autocmd FileType netrw setl bufhidden=delete

lua require('config')

