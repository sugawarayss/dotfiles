-- local pyproject_path = require("utils").find_project_root({ "pyproject.toml" })

return {
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  -- LSPの設定
  settings = {
    init_options = {
      settings = {
        configuration = require("utils").find_project_root({ "pyproject.toml" }) .. "/pyproject.toml",
        -- ワークスペース内に存在する設定ファイル(ruff.toml/pyproject.toml)を以下の設定より優先する
        configurationPreference = "filesystemFirst",
        -- リンティングとフォーマットから除外するファイルパターンリスト
        exclude = { "**/migrations/**" },
        -- lint/format 時の1行の長さ
        lineLength = 150,
        -- import 文のソートをコードアクションに追加
        organizeImports = false,
        -- 構文エラー診断を表示する
        showSyntaxErrors = true,
        -- fixALL をコードアクションに追加
        fixAll = true,
        codeAction = {
          -- `noqa` でルールを無視するコメントを追記するアクションを表示する
          disableRuleComment = { enable = true },
          -- 違反を自動修正するためのクイック修正アクションを表示する
          fixViolation = { enable = true },
        },
        -- リンティング設定
        lint = {
          enable = true,
          -- 不安定なルールは適用しない
          preview = false,
          -- 有効にするルール
          select = {},
          -- 追加で有効にするルール
          extendSelect = { "I" },
          -- 無効にするルール
          ignore = {},
        },
        format = {
          -- 不安定なルールは適用しない
          preview = false,
        },
      },
    },
  },
}
