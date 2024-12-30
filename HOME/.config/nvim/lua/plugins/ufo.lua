-- コード折り畳みプラグイン
local ftMap = {
  vim = "indent",
  python = { "indent" },
  git = "",
}
-- 折り畳んだ範囲の行数をvirtual textで表示
local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix      = (" 󰁂 %d "):format(endLnum - lnum)
    local sufWidth    = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth    = 0
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
  "kevinhwang91/nvim-ufo",
  enabled = true,
  dependencies = { "kevinhwang91/promise-async" },
  -- 遅延読み込みする
  lazy = true,
  event = "VeryLazy",
  keys = {
    { "zr", function() require("ufo").openAllFolds() end,  mode = "n", desc = "すべての折り畳みを展開" },
    { "zm", function() require("ufo").closeAllFolds() end, mode = "n", desc = "すべてを折り畳み" },
  },
  config = function()
    vim.api.nvim_set_option("fillchars", [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]])
    vim.api.nvim_set_option("foldcolumn", "2")
    vim.api.nvim_set_option("foldlevel", 99)
    vim.api.nvim_set_option("foldlevelstart", 99)
    vim.api.nvim_set_option("foldenable", true)
    require("ufo").setup({
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = {
        default = { "imports", "comment" },
        json = { "array" },
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
      provider_selector = function(_, filetype, _)
        return ftMap[filetype] or { "treesitter", "indent" }
      end,
    })
  end
}
