" Plugins
call plug#begin('~/.vim/plugged')
Plug 'https://github.com/rakr/vim-one' " vim-one color theme
Plug 'scrooloose/nerdtree'           " side bar file tree
Plug 'itchyny/lightline.vim'         " minmal status bar
Plug 'tpope/vim-fugitive'            " allows git commands in vim session
Plug 'airblade/vim-gitgutter'        " shows git changes in gutter
Plug 'easymotion/vim-easymotion'     " go to any word quickly '\\w', '\\e', '\\b'
Plug 'KKPMW/vim-sendtowindow'        " send commands to REPL
Plug 'yuttie/comfortable-motion.vim' " scrolling 'C-d' or 'C-u'

if has('nvim')
 Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
 Plug 'Shougo/deoplete.nvim'
 Plug 'roxma/nvim-yarp'
 Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

Plug 'Shougo/neco-vim'
Plug 'ncm2/ncm2'                     " completion [dep]: nvim-0.2.2, nvim-yarp, python3

"autocmd BufEnter * call ncm2#enable_for_buffer()
"IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

Plug 'ncm2/ncm2-bufword'             " complete words in buffer
Plug 'ncm2/ncm2-path'                " complete paths
Plug 'ncm2/ncm2-jedi'                " Python completion

Plug 'dense-analysis/ale'            " linting [dep]: pip3 install flake8, install.packages('lintr')
Plug 'fisadev/vim-isort'             " Python sort imports [dep]: pip3 install isort
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'mhinz/vim-startify'            " A start menu for vim
Plug 'tpope/vim-surround'            " replace surrounding characters
Plug 'filipekiss/ncm2-look.vim'      " ncm2 spelling
Plug 'SirVer/ultisnips'              " hotkeys for chunks of code
Plug 'tmhedberg/SimpylFold'          " Code folding (zo: open, zc: close)
Plug 'rust-lang/rust.vim'            " Rust format
Plug 'vimwiki/vimwiki'               " Note taking 
Plug 'https://github.com/tpope/vim-surround' " bracket handling
Plug 'junegunn/fzf', {'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
call plug#end()

" ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

" call deoplete#custom#option('num_processes', 1)

" ncm2-loom
let g:ncm2_look_enabled = 1

" turn on spelling and make a spell file
set spelllang=en_us
set spellfile=~/.config/nvim/en.utf-8.add

:syntax on 
:hi Visual term=reverse cterm=reverse guibg=Grey
" startify
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'files',     'header': ['   Recent']            },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

" This is the default extra key bindings
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'
  
  
" nerdtreeder>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :Marks<CR>settings

let g:fzf_tags_command = 'ctags -R'
" Border color
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'
let $FZF_DEFAULT_COMMAND="rg --files --hidden"

" customize fzf colors to match your color scheme
let g:fzf_colors =
      \ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Get Files
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

" Get text in files with Rg
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" Rigprep advanced
function! RipgrepFzf(query, fullscreen)
 let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
 let initial_command = printf(command_fmt, shellescape(a:query))
 let reload_command = printf(command_fmt, '{q}')
 let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
 call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Git grep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" ---------------------------------------------------------------------

map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']  " ignore pyc files

" remap esc in insert mode to kj
inoremap kj <esc>

" Window Splits
set splitbelow splitright
" Remap splits navigation to just CTRL + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Make adjusing split sizes a bit more friendly
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :res -3<CR>
noremap <silent> <C-Down> :res +3<CR>
" noremap <Leader>up :res -3<CR>  
" Change 2 split windows from vert to horiz or horiz to vert
map <Leader>th <C-w>t<C-w>H
map <Leader>tk <C-w>t<C-w>K

" Start terminals for R and Python sessions '\tr' or '\tp'
map <Leader>tp :new<cr>:term<CR>ipy3<CR><C-\><C-n><C-w>k

tnoremap <Esc> <C-\><C-n>

" General Settings
set number                      " set line numbers
set updatetime=100              " set update time for gitgutter update
set noswapfile                  " no swap
set clipboard=unnamedplus       " Copy/paste between vim and other programs. '"+y' then middlemouse
" tabs and spaces
set expandtab                   " Use spaces instead of tabs.
set smarttab                    " Uses shiftwidth and tabstap to insert blanks when <Tab>
set shiftwidth=2                " One tab == four spaces.
set tabstop=2                   " One tab == four spaces.<Past

let g:python3_host_prog='/home/alexis/.pyenv/shims/python' "ncm2-jedi
let g:vimwiki_list = [{'path':'~/git/vim/vimwiki', 'path_html':'~/git/vim/vimwiki_html'}]
" Start terminals for R and Python sessions '\tr' or '\tp'
map <Leader>tp :new term://bash<CR>ipython<CR><C-\><C-n><C-w>k

" markdown-preview.nvim
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_open_ip = ''
let g:mkdp_browser = ''
let g:mkdp_echo_preview_url = 0
let g:mkdp_browserfunc = ''
let g:mkdp_preview_options = {
   \ 'mkit': {},
   \ 'katex': {},
   \ 'uml': {},
   \ 'maid': {},
   \ 'disable_sync_scroll': 0,
   \ 'sync_scroll_type': 'middle',
   \ 'hide_yaml_meta': 1
   \ }
let g:mkdp_markdown_css = ''
let g:mkdp_highlight_css = ''
let g:mkdp_port = ''
let g:mkdp_page_title = '「${name}」'
                                 
"vim-isort 

let g:vim_isort_map = '<C-i>'

" Ale Linting
let g:ale_sign_column_always=1
let g:ale_lint_on_enter=1
let g:ale_lint_on_text_changed='always'
let g:ale_echo_msg_error_str='E'
let g:ale_echo_msg_warning_str='W'
let g:ale_echo_msg_format='[%linter%] %s[%severity%]: [%...code...%]'
let g:ale_linters={'python': ['flake8'], 'r': ['lintr']}
let g:ale_fixers={'python': ['black']}

" ncm2 
"autocmd BufEnter * call ncm2#enable_for_buffer()      " enable ncm2 for all buffers
"set completeopt=noinsert,menuone,noselect             " IMPORTANT: :help Ncm2PopupOpen for more information

" gitgutter
let g:gitgutter_async=0

" Theme settings
" colorscheme one                  " use vim-one colorscheme
let g:airline_theme='murphy'
