-- 日本語IME
return {
  {
    "vim-skk/skkeleton",
    dependencies = {
      "vim-denops/denops.vim",
      "Shougo/ddc.vim",
      "delphinus/skkeleton_indicator.nvim"
    },
    lazy = true,
    event = "BufReadPre",
    keys = {
      { "<C-j>", "<Plug>(skkeleton-toggle)", mode = "i", desc = "Toggle IME" },
      { "<C-j>", "<Plug>(skkeleton-toggle)", mode = "c", desc = "Toggle IME" },
    },
    config = function()
      local dictionaries = {}
      local handle = io.popen("ls $HOME/.skk/*")
      if handle then
        for file in handle:lines() do
          table.insert(dictionaries, { file, "euc-jp" })
        end
        handle:close()
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "skkeleton-initialize-pre",
        callback = function()
          vim.fn["skkeleton#config"]({
            eggLikeNewline = true, -- 変換モードで改行キーを押した際に確定のみを行う
            registerConvertResult = true, -- カタカナ変換結果を辞書に登録する
            globalDictionaries = dictionaries, -- グローバル辞書を指定
          })
        end,
      })

      -- 英字モードのハイライトカラー定義
      vim.api.nvim_set_hl(0, "SkkeletonIndicatorEiji", { fg = "#2e3440", bg = "#a3be8c" })
      -- ひらがなモードのハイライトカラー定義
      vim.api.nvim_set_hl(0, "SkkeletonIndicatorHira", { fg = "#88c0d0", bg = "#2e3440" })
      -- カタカナモードのハイライトカラー定義
      vim.api.nvim_set_hl(0, "SkkeletonIndicatorKata", { fg = "#2e3440", bg = "#ebcb8b" })
      -- 半角カタカナモードのハイライトカラー定義
      vim.api.nvim_set_hl(0, "SkkeletonIndicatorHankata", { fg = "#2e3440", bg = "#b48ead" })
      -- 全角モードのハイライトカラー定義
      vim.api.nvim_set_hl(0, "SkkeletonIndicatorZenkaku", { fg = "#2e3440", bg = "#88c0d0" })
      -- 全角英字モードのハイライトカラー定義
      vim.api.nvim_set_hl(0, "SkkeletonIndicatorAbbrev", { fg = "#e5e9f0", bg = "#bf616a" })

      require("skkeleton_indicator").setup({
        -- 英字モードのハイライトグループを指定
        eijiHlName = "SkkeletonIndicatorEiji",
        -- ひらがなモードのハイライトグループを指定
        hiraHlName = "SkkeletonIndicatorHira",
        -- カタカナモードのハイライトグループを指定
        kataHlName = "SkkeletonIndicatorKata",
        -- 半角カタカナモードのハイライトグループを指定
        hankataHlName = "SkkeletonIndicatorHankata",
        -- 全角モードのハイライトグループを指定
        zenkakuHlName = "SkkeletonIndicatorZenkaku",
        -- 全角英字モードのハイライトグループを指定
        abbrevHlName = "SkkeletonIndicatorAbbrev",
        -- 英字モードの表示文字列を指定
        eijiText = "英字",
        -- ひらがなモードの表示文字列を指定
        hiraText = "ひら",
        -- カタカナモードの表示文字列を指定
        kataText = "カタ",
        -- 半角カタカナモードの表示文字列を指定
        hankataText = "半ｶﾀ",
        -- 全角英数モードの表示文字列を指定
        zenkakuText = "全英",
        -- abbrモードの表示文字列を指定
        abbrevText = "abbr",
        -- 枠線のスタイルを指定
        border = "rounded",
        -- カーソル位置を元にインジケータの表示位置(縦)を指定
        row = 0,
        -- カーソル位置を元にインジケータの表示位置(横)を指定
        col = 1,
        -- インジケータのz軸を指定
        zindex = nil,
        -- 常時表示(IMEがon時にのみ表示)
        alwaysShown = false,
        -- インジケータの表示時間(ミリ秒)を指定
        fadeOutMs = 3000,
        -- インジケータを表示しないファイルタイプを指定
        ignoreFt = {},
        -- インジケータを表示するか判定する関数を指定(引数はバッファ番号)
        bufFilter = function(_) return true end,
      })
    end
  }
}
