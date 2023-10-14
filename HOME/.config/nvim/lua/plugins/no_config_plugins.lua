return {
  -- 一括コメントアウト
  { "tpope/vim-commentary" },
  -- w/bモーションでの移動をスマートにする
  { "kana/vim-smartword" },
  -- 入力時、シグネチャの情報を表示
  { "ray-x/lsp_signature.nvim" },
  -- 対応するキーワードや記号にジャンプできる
  { "andymass/vim-matchup" },
  -- コードとテストコードのファイルを行き来できるプラグイン
  { "rgroli/other.nvim" },
  -- Github copilot
  { "github/copilot.vim" },
  -- ウィンドウサイズを調整できる
  { "simeji/winresizer", lazy = false },
  -- csv 操作を便利に
  { "mechatroner/rainbow_csv" },
  -- ステータスバーにgitbranchを表示するプラグイン
  { "itchyny/vim-gitbranch" },
  -- バッファ領域にコマンドの出力結果を表示する
  { "tyru/capture.vim" },
  -- Insert Mode時に絶対行表示にする
  { "myusuf3/numbers.vim" },
  -- focusがないペインを暗く表示する
  { "sunjon/shade.nvim" },
  -- markdownをプレビューできるプラグイン
  { "iamcco/markdown-preview.nvim", ft = {"markdown" }, build = function() vim.fn["mkdp#util#install"]()  end, },
}
