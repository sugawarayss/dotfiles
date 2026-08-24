-- Treesitterを使用してHTMLタグを自動的に閉じるプラグイン
return {
  "windwp/nvim-ts-autotag",
  lazy = false,
  config = function()
    require("nvim-ts-autotag").setup({
      opts = {
        -- 自動タグ閉じ
        enable_close = true,
        -- 自動タグリネーム
        enable_rename = true,
        -- </ で自動タグ閉じ
        enable_close_on_slash = true,
      },
      per_filetype = {},
    })
  end,
}
