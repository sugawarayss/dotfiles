let g:rehash256 = 1
set ttimeoutlen=10               " キー入力完了を待つ時間(ミリ秒)
" フォントの設定
set guifont=Ricty\ Diminished:h20

""""""""""""""""""""
" GENERAL SETTINGS
""""""""""""""""""""
set autochdir                    " 開いているファイルのあるディレクトリをカレントにする
set noundofile                   " undoファイルを自動作成しない
scriptencoding utf-8             " vim scriptでマルチバイト文字を使う場合
set encoding=utf-8               " ファイルを開く時のデフォルト文字コード
set fenc=utf-8                   " 文字コードをUTF-8に設定
set nobackup                     " バックアップファイルを作らない
set noswapfile                   " スワップファイルを作らない
set nowritebackup                " 上書き保存時にバックアップをつくることを無効化
set autoread                     " 編集中のファイルが変更されたら自動で読み直す
set hidden                       " バッファが編集中でもその他のファイルを開けるようにする
" ステータス行に情報表示
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
" バッファで開いているファイルのディレクトリでエクスクローラを開始する
set browsedir=buffer
" ESCでコマンドモード時にIMEを自動OFF
if has('multi_byte_ime') || has('xim') || has('gui_macvim')
  " Insert mode: lmap off, IME ON
  set iminsert=2
  " Serch mode: lmap off, IME ON
  set imsearch=2
  " Normal mode: IME off
  inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
elseif has('mac')
  "インサートモードを抜ける時に英数キーを押してIME解除
  augroup insertLeave
    autocmd!
    autocmd InsertLeave * :call system('osacript -e "tell application \"System Events\" to key code 102"')
  augroup END
endif

""""""""""""""""""""
" VISUAL SETTINGS
""""""""""""""""""""
set termguicolors                " ターミナルでもカラーテーマを使う
colorscheme codedark             " カラーテーマをvscodedarkに変更https://github.com/tomasiser/vim-code-dark.git
"colorscheme monokai_pro          " カラーテーマをmonokai_proに変更https://github.com/phanviet/vim-monokai-pro
set winblend=30                  " 現在のウィンドウの透明度を指定0〜100
set pumblend=10                  " ポップアップメニューを半透明にする0〜100
"set background=dark              " 暗い背景色に合う色を使用する
set t_Co=256                     " 256色対応する
set number                       " 行番号を表示
" ウインドウのタイトルバーにファイルのパス情報等を表示する
set title
set list                         " 不可視文字の可視化
set ruler                        " カーソル位置が右下に表示される
set showmode                     " 現在のモードを表示する
set showcmd                      " コマンドを画面の最下部に表示する
set smartindent                  " インデントはスマートインデント
set visualbell                   " ビープ音を可視化
set laststatus=2                 " ステータスラインを常に表示する
set wildmenu                     " コマンドラインの補完
syntax on                        " シンタックスハイライトの有効化
"syntax enable                    " シンタックスハイライトの有効化
set wrap                         " 長いテキストの折り返し
set textwidth=0                  " 自動的に改行が入るのを無効化
set colorcolumn=100              " 100文字目にラインを入れる
set cursorline                   " カーソル行にラインを入れる
set foldmethod=indent            " 折りたたみ
set foldlevel=100                " ファイルを開く時に折りたたみをしない

""""""""""""""""""""
" EDITER SETTINGS
""""""""""""""""""""
set backspace=2   " バックスペースでインデント、行末、挿入開始点を超えて消去可能にする
set infercase                    " 補完時に大文字小文字を区別しない
set virtualedit=all              " カーソルを文字が存在しない部分でも動けるようにする
set hidden                       " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen            " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch                    " 対応する括弧などをハイライト表示する
set matchtime=3                  " 対応括弧のハイライト表示を3秒にする
set autoindent                   " 改行時にインデントを引き継いで改行する
set shiftwidth=4                 " インデントにつかわれる空白の数
au BufNewFile,BufRead *.yml set shiftwidth=2
set softtabstop=4                " <Tab>押下時の空白数
set expandtab                    " <Tab>押下時に<Tab>ではなく、ホワイトスペースを挿入する
set tabstop=4                    " <Tab>が対応する空白の数
au BufNewFile,BufRead *.yml set tabstop=2
set shiftround                   " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set nf=                          " インクリメント、デクリメントを10進数にする
set matchpairs& matchpairs+=<:>  " 対応括弧に'<'と'>'のペアを追加
set backspace=indent,eol,start   " バックスペースでなんでも消せるようにする
set list
set list listchars=tab:»-,space:-,trail:-,eol:↲,extends:»,precedes:«,nbsp:% " tab文字、改行文字、右端省略、左端省略、空白文字を表示する
" {}と()の閉じ括弧を自動で挿入してスコープ内は自動インデントする
" inoremap { {}<Left>
" inoremap {<Enter> {}<Left><CR><ESC><S-o>
" inoremap () ()
" inoremap ( ()<ESC>i
" inoremap (<Enter> ()<Left><CR><ESC><S-o>
" inoremap [ []<ESC>i
" inoremap [<Enter> []<Left><CR><ESC><S-o>

" 'と"と<>を自動補完する
" inoremap '' ''
" inoremap' ''<ESC>i
" inoremap "" ""
" inoremap " ""<ESC>i
" inoremap < <><ESC>i

" インサートモードのままカーソル移動
" Ctrl+fで一つ右へ移動
inoremap <C-f> <C-g>U<Right>
" Ctrl+f Ctrl+fで一番外へ移動
inoremap <C-f><C-f> <C-g>U<ESC><S-a>

" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在しているかどうかで設定を分ける必要がある
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus,unnamed
else
    set clipboard& clipboard+=unnamed
endif

" 全角スペースの表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif
""""""""""""""""""""""""""""""

""""""""""""""""""""
" SEARCH SETTINGS
""""""""""""""""""""
set ignorecase                   " 大文字小文字を区別しない
set smartcase                    " 検索文字に大文字がある場合は大文字小文字を区別する
set incsearch                    " インクリメンタルサーチ
set hlsearch                     " 検索マッチテキストをハイライト
" Escの2回押しで検索ハイライト消去
nmap <ESC><ESC> ;nohlsearch<CR><ESC>

" バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %

" insertモードから抜けるキーバインド
inoremap <silent> jj <ESC> " jj
inoremap <silent> kk <ESC> " kk

filetype indent on

" dein------------------------------------------------------------
" Required:
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state($HOME . '/.cache/dein')
  call dein#begin($HOME . '/.cache/dein')

  let s:toml_dir  = $HOME . '/.config/nvim/dein/toml'
  let s:toml      = s:toml_dir . '/dein.toml'
  let s:lazy_toml = s:toml_dir . '/dein_lazy.toml'

  " TOMLを読み込んでキャッシュ
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " Let dein manage dein
  " Required:
  call dein#add($HOME . '/.cache/dein/repos/github.com/Shougo/dein.vim')

  " You can specify revision/branch/tag.
  " call dein#add('Shougo/deol.nvim', { 'rev': 'a1b5108fd' })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
