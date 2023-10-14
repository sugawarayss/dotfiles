-- FIXME:
local options = {
  encoding = "utf-8",                          -- 文字コードの指定
  fileencoding = "utf-8",                      -- ファイル文字コードの指定
  shell = "zsh",                               -- :!コマンドで使用するシェル
  mouse = "a",                                 -- マウスを利用可能にする
  title = true,                                -- ウィンドウタイトルにファイル名を使用する
  backup = false,                              -- ファイル上書き保存時にバックアップファイルを作成しない
  undofile = true,                             -- バッファをファイルに保存したときにアンドゥ履歴をファイルに自動保存する
  swapfile = false,                            -- バッファでスワップファイルを使用する
  updatetime = 300,                            -- スワップファイルがディスクに書き込まれる猶予時間(ミリ秒)
  backupskip = { "/tmp/*", "/private/tmp/*" }, -- ファイルバックアップを作成しないファイル名パターン
  clipboard = "unnamedplus",                   -- クリップボードを連携
  cmdheight = 2,                               -- コマンド部は2行分の高さ
  completeopt = { "menuone", "noinsert" },     -- 補完時の設定 menuone: 候補が1つしかなくてもポップアップする。 noinsert: メニューから選択しない限り入力しない
  conceallevel = 0,                            -- conceal構文属性のテキストでも通常通り表示する
  -- 検索系設定 --
  hlsearch = true,                             -- 検索パターンにマッチするテキストを強調表示
  ignorecase = true,                           -- 検索時に大文字小文字を区別しない
  smartcase = true,                            -- 検索パターンに大文字を含んでいたら区別する
  pumheight = 10,                              -- 挿入モード補完のポップアップ表示数の最大値
  showmode = false,                            -- 現在のモード名称を表示
  showtabline = 2,                             -- タブページのラベルは常に表示
  smartindent = true,                          -- 改行時に高度な自動インデントを行う
  termguicolors = true,                        -- 24bitカラーを使用可能にする
  timeoutlen = 300,                            -- キーマッピングが完了するまでの時間(ミリ秒)
  writebackup = false,                         -- ファイル上書きの前にバックアップを作らない
  expandtab = true,                            -- 挿入モード時に<TAB>で空白を使用する
  shiftwidth = 2,                              -- インデントに使用する空白の数
  tabstop = 4,                                 -- ファイル内の<TAB>に対応する空白の数
  cursorline = true,                           -- カーソル行を強調表示
  number = true,                               -- 行番号を表示
  relativenumber = true,                       -- 相対行番号で表示する
  numberwidth = 4,                             -- 行番号部の幅
  signcolumn = "yes",                          -- 目印桁は常に表示する
  wrap = false,                                -- 折返しはしない
  wildoptions = "pum",                         -- コマンドライン補完をポップアップメニューで表示
  background = "dark",                         -- 暗い背景色を使用
  scrolloff = 8,                               -- スクロール時に上下に余分に表示するサイズ
  sidescrolloff = 8,                           -- 横スクロール時に左右に余分に表示するサイズ
  guifont = "Hack Nerd Font:h20",              -- フォント指定
  splitbelow = false,                          -- オンのとき、ウィンドウを横分割すると新しいウィンドウはカレントウィンドウの下に開かれる
  splitright = false,                          -- オンのとき、ウィンドウを縦分割すると新しいウィンドウはカレントウィンドウの右に開かれる
  pumblend = 10,                               -- pop upメニュー(補完時のポップアップ)を半透明にする
  winblend = 10,                               -- 任意のfloating windowを半透明にする
}

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]]) -- TODO: this doesn't seem to work
