-- marp で markdown からスライドを作成し易くする
if vim.g.vscode then
  return {}
else
  return {
    "nwiizo/marp.nvim",
    ft = "markdown",
    config = function()
      require("marp").setup({
        -- homebrew でインストールした場合
        marp_command = "/opt/homebrew/opt/node/bin/node /opt/homebrew/bin/marp",
        -- 未インストールの場合(npxで実行)
        -- marp_command = "npx @marp-team/marp-cli@latest",

        -- ブラウザコマンド(nil = 自動検出)
        browser = nil,

        -- 利用可能なテーマ
        export_formats = {
          html = "--html",
          pdf = "--pdf",
          pptx = "--pptx",
          png = "--images png",
          jpeg = "--images jpeg",
        },

        -- 便利なヒントを表示
        show_tips = true,
        -- ファイルパスを自動でクリップボードにコピー
        auto_copy_path = true,
        -- エクスポート後にファイルサイズを表示
        show_file_size = true,
        -- *.htmlを.gitignoreに追加するよう提案する
        suggest_gitignore = true,
        -- デバッグログを有効化(トラブルシューティング用)
        debug = false,
        -- サーバモード(-s) またはウォッチモード(--watch)を使用
        server_mode = false,
      })
    end,
  }
end
