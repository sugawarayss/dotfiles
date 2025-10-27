-- 日本語IME
return {
  {
    "vim-skk/skkeleton",
    lazy = false,
    event = "BufReadPre",
    init = function()
      local wk = require("which-key")
      wk.add({
        { "<C-j>", "<Plug>(skkeleton-toggle)", mode = { "i", "c" }, icon = "", desc = "IMEをトグル" },
      })
    end,
    config = function()
      local dictionaries = {}
      local handle = io.popen("ls ~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.L")
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
            acceptIllegalResult = true, -- 入力に失敗したローマ字がバッファに残る
            eggLikeNewline = true, -- 変換モードで改行キーを押した際に確定のみを行う
            registerConvertResult = true, -- カタカナ変換結果を辞書に登録する
            globalDictionaries = dictionaries, -- グローバル辞書を指定
            showCandidatesCount = 999, -- 候補表示数
            userDictionary = "~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/my_dictionary",
          })
        end,
      })

      local color_palette = require("onedark.colors")
      -- 英字モードのハイライトカラー定義
      vim.api.nvim_set_hl(0, "SkkeletonIndicatorEiji", { fg = color_palette.yellow, bg = color_palette.bg_d })
      -- ひらがなモードのハイライトカラー定義
      vim.api.nvim_set_hl(0, "SkkeletonIndicatorHira", { fg = color_palette.blue, bg = color_palette.bg_d })
      -- カタカナモードのハイライトカラー定義
      vim.api.nvim_set_hl(0, "SkkeletonIndicatorKata", { fg = color_palette.green, bg = color_palette.bg_d })
      -- 半角カタカナモードのハイライトカラー定義
      vim.api.nvim_set_hl(0, "SkkeletonIndicatorHankata", { fg = color_palette.purple, bg = color_palette.bg_d })
      -- 全角モードのハイライトカラー定義
      vim.api.nvim_set_hl(0, "SkkeletonIndicatorZenkaku", { fg = color_palette.cyan, bg = color_palette.bg_d })
      -- 全角英字モードのハイライトカラー定義
      vim.api.nvim_set_hl(0, "SkkeletonIndicatorAbbrev", { fg = color_palette.red, bg = color_palette.bg_d })

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
        row = -3,
        -- カーソル位置を元にインジケータの表示位置(横)を指定
        col = 0,
        -- インジケータのz軸を指定
        zindex = nil,
        -- 常時表示(IMEがon時にのみ表示)
        alwaysShown = true,
        -- インジケータの表示時間(ミリ秒)を指定
        fadeOutMs = 5000,
        -- インジケータを表示しないファイルタイプを指定
        ignoreFt = {},
        -- インジケータを表示するか判定する関数を指定(引数はバッファ番号)
        bufFilter = function(_)
          return true
        end,
      })
    end,
  },
  { "vim-denops/denops.vim" },
  { "Shougo/ddc.vim" },
  {
    "delphinus/skkeleton_indicator.nvim",
    enabled = true,
    event = "BufReadPre",
    version = "v2",
    opts = {},
  },
}
