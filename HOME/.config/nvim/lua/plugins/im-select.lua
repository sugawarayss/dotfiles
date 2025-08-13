-- Neovimのイベント時にimeを操作するプラグイン
return {
  "keaising/im-select.nvim",
  lazy=false,
  config = function()
    require("im_select").setup({
      -- NOTE:
      --   im-select のインストールが必要
      --   `brew tap daipeihust/tap`
      --   `brew install im-select`
      default_command = "im-select",
      -- デフォルトのime は英数
      default_im_select = "com.apple.keylayout.ABC",
      -- デフォルトのIMEに変更するイベント
      set_default_events = {
        "VimEnter", -- Vim起動時
        "InsertLeave", -- INSERTモードを抜けたとき
        "CmdlineEnter", -- コマンドラインに入ったとき
        "CmdlineLeave", -- コマンドラインを抜けたとき
      },
      -- 前回使われていたIMEに変更するイベント
      set_previous_events = {
        "InsertEnter", -- INSERTモードに入ったとき
      },
      -- 実行可能なコマンドが見つからなかった場合に通知を表示する
      keep_quiet_on_no_binary = false,
      -- `default_command` を非同期で実行する
      async_switch_im = true,
    })
  end,
}
