" UTF-8 LF

" vundleの設定
" viと互換モードにしない
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'vim-scripts/wombat256.vim'
Bundle 'Shougo/neocomplcache'
Bundle 'vim-scripts/indenthtml.vim'
Bundle 'vim-jp/vimdoc-ja'
Bundle 'vim-scripts/sh.vim'
Bundle 'manic/vim-php-indent'


" pluginとindentをon
filetype plugin indent on
" 256色にする
set t_Co=256
" colorsheme
colorscheme wombat256mod
" titleを表示
set title
" 行番号を表示
set number
" ルーラーを表示
set ruler
" バックアップとスワップなし
set nobackup
set noswapfile
" タブの代わりに半角スペース
set expandtab
" タブ4文字分
set tabstop=4
set softtabstop=4
set shiftwidth=4
" 自動的にインデントする
set autoindent
set smartindent
" vimの内部の文字コード
set encoding=utf-8
" スクリプトで使われている文字コード
scriptencoding utf-8
" 保存する時の文字コード
set fileencoding=utf-8
" 開く時の文字コード
set fileencodings=utf-8,cp932,euc-jp
" 端末の文字コード
set termencoding=utf-8
" 保存する時の改行コード
set fileformat=unix
" 開く時の改行コード
set fileformats=unix,dos
" 折り返ししない
set nowrap
" 大文字小文字を区別せず検索、大文字がある場合区別する
set ignorecase
set smartcase
" インクリメントサーチを無効
set noincsearch
" 最後まで検索しても最初に戻らない
set nowrapscan
" 括弧入力時に対応する括弧を表示
set showmatch
" ステータスラインを表示し、ファイル名_文字コード_改行コード_ルーラーの順にして色も変える
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
" シンタックスハイライトを有効
syntax on
" クリップボードの共有
set clipboard=unnamed
" コマンドモードでlinuxの端末の補完みたいにする
set wildmode=list,full
" 挿入か置換を表示
set showmode
" 行間
set linespace=0
" コマンドラインを2行分
set cmdheight=2
" 検索のハイライト無効
set nohlsearch
" viminfoファイルを作成、使用しない
set viminfo=
" guiなし
set guioptions=
" backspaceでindent,改行,以前入力した文字を削除できるようにする
set backspace=indent,eol,start
" beep無効
set visualbell t_vb=
" 文頭や文末で左右に動いたら次の行や前の行にいけるようにする
set whichwrap=b,s,h,l,<,>,[,]
" タブ文字とか半角とか色々を可視化
set list
set lcs=tab:>.,trail:_,extends:\
" スクロールに余裕をもたせる
set scrolloff=5
set sidescrolloff=5
set sidescroll=1
" 入力中コマンドを右下に表示
set showcmd
" カレントディレクトリをバッファで開いているファイルが存在しているディレクトリに自動切り替え
set autochdir
" 保存しなくてもバッファ切り替え可
set hidden
" 一行のどこまでの文字数までsyntaxを有効にするか(0:無限)
set synmaxcol=0
" 勝手に改行させない
set textwidth=0
" 保存時にディレクトリがなくても確認して作成する
augroup vimrc-auto-mkdir
    autocmd!
    autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
    function! s:auto_mkdir(dir, force)
        if !isdirectory(a:dir) && (a:force ||
                    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
            call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
        endif
    endfunction
augroup END
" indent/html.vimの設定
let g:html_indent_script1="inc"
let g:html_indent_style1="inc" 
let g:html_indent_inctags="html,body,head"
" *.f90
let fortran_free_source=1
let fortran_fold=1
autocmd BufNewFile,BufRead *.f90 let b:fortran_do_enddo=1
" .uim
autocmd BufNewFile,BufRead .uim set filetype=scheme
" .vimperatorrc
autocmd BufNewFile,BufRead .vimperatorrc set filetype=vimperator
" *.ebuild
autocmd BufNewFile,BufRead *.ebuild set textwidth=0
" *.sh
autocmd BufNewFile,BufRead *.sh set filetype=sh
let g:sh_indent_case_labels=1
" enable neocomplcache
let g:neocomplcache_enable_at_startup=1
