set encoding=utf-8
scriptencoding utf-8

function! s:ensure_dir(dir)
  if filewritable(a:dir) != 2
    call mkdir(a:dir, "p", 0700)
  endif
endfunction

if exists('+packpath')
  " These are really clever - minpac will actually be loaded on the fly only
  " when you need to update or clean your packages, rather than all the time.
  command! PackUpdate source $XDG_CONFIG_HOME/vim/plugins.vim | call minpac#update('', {'do': 'call minpac#status()'})
  command! PackClean  source $XDG_CONFIG_HOME/vim/plugins.vim | call minpac#clean()
  command! PackStatus source $XDG_CONFIG_HOME/vim/plugins.vim | call minpac#status()

  " If the pack directory doesn't exist, we haven't installed any packages yet,
  " so let's call PackUpdate.
  if !isdirectory($XDG_CACHE_HOME . '/vim/pack')
    PackUpdate
  endif
else
  " If we're on a version of Vim that doesn't have packages, we have to load a
  " plugin manager (vim-plug) on every boot.
  source $XDG_CONFIG_HOME/vim/plugins.vim
endif

augroup transparent_term
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
augroup END
set background=dark
let g:gruvbox_italic=1
let g:gruvbox_improved_strings=1
let g:gruvbox_improved_warnings=1

if has('gui_running') || has('termguicolors')
  set termguicolors
  silent! packadd gruvbox
  let g:airline_theme = 'gruvbox'
  colorscheme gruvbox
else
  colorscheme inkpot
endif

inoremap jj <Esc>
nnoremap <C-t> :Files<CR>


if exists('+belloff')
  set belloff+=ctrlg
endif

set completeopt+=menuone

set linebreak showbreak=↩
set showcmd
set wildmode=longest,full

set tabstop=2 shiftwidth=2

if exists('+breakindent')
  set breakindent breakindentopt=sbr
endif

if exists('+relativenumber')
  set relativenumber
else
  set number
endif

for s:dir in ['backup', 'swap', 'undo']
  call s:ensure_dir($XDG_CACHE_HOME . '/vim/' . s:dir)
endfor

set backupdir=.,$XDG_CACHE_HOME/vim/backup
set directory=.,$XDG_CACHE_HOME/vim/swap
if exists('+undofile')
  set undofile
  set undodir=$XDG_CACHE_HOME/vim/undo
endif

let g:airline_powerline_fonts = 1
let g:LatexBox_Folding = 1
let g:NERDTreeHijackNetrw = 1

let g:ale_set_balloons = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:mucomplete#can_complete = {
  \'default': {
    \'omni': {t -> strlen(&l:omnifunc) > 0 && t =~# '\m\k\%(\k\|\.\)$'}
  \}
\}
