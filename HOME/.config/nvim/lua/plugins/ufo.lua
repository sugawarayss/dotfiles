-- コード折り畳みプラグイン
local ftMap = {
  vim = "indent",
  python = { "indent" },
  git = "",
  snacks_dashboard = "",
}
-- 折り畳んだ範囲の行数をvirtual textで表示
local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" 󰁂 %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      local hlGroup = chunk[2]
      chunkText = truncate(chunkText, targetWidth - curWidth)
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

-- 折りたたみ
return {
  {
    "kevinhwang91/nvim-ufo",
    enabled = true,
    -- 遅延読み込みする
    lazy = true,
    event = "VeryLazy",
    init = function()
      local wk = require("which-key")
      wk.add({
        {
          "zr",
          function()
            require("ufo").openAllFolds()
          end,
          mode = { "n" },
          icon = "",
          desc = "Ufo - すべての折り畳みを展開",
        },
        {
          "zm",
          function()
            require("ufo").closeAllFolds()
          end,
          mode = { "n" },
          icon = "",
          desc = "Ufo - すべてを折り畳み",
        },
      })
    end,
    config = function()
      vim.opt.fillchars = {
        -- ファイルの終わりを示す表示文字
        eob = " ",
        -- 折り畳み表示用の文字
        foldclose = "",
        -- 展開表示用の文字
        foldopen = "",
        -- 折り畳み範囲の区切り文字
        foldsep = " ",
        -- INFO: Neovim 0.12以降
        -- 折り畳み範囲のネスト深度を示す表示文字
        foldinner = " ",
      }
      -- 折り畳み表示用のカラム幅
      vim.opt.foldcolumn = "1"
      -- すべての折り畳みを展開
      vim.opt.foldlevel = 99
      -- 新しいバッファでの折り畳みレベルの初期値
      vim.opt.foldlevelstart = 99
      -- 折り畳みを有効にする
      vim.opt.foldenable = true
      require("ufo").setup({
        -- 折り畳みを開いた時の範囲のハイライト秒数(ミリ秒)
        open_fold_hl_timeout = 400,
        -- A function as a selector for providers.
        provider_selector = function(_, filetype, _)
          return ftMap[filetype] or { "treesitter", "indent" }
        end,
        -- バッファを開いた時に自動で閉じておくファイルタイプ別の折り畳みの種類
        close_fold_kinds_for_ft = {
          default = { "imports" },
          -- json = { "array" },
        },
        preview = {
          win_config = {
            border = { "", "-", "", "", "", "-", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrolU = "<C-u>",
            scrolD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
        fold_virt_text_handler = handler,
      })
    end,
  },
  { "kevinhwang91/promise-async" },
}
