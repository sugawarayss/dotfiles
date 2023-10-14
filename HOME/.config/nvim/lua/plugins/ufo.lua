local ftMap = {
  vim = "indent",
  python = { "indent" },
  git = "",
}
-- 折り畳んだ範囲の行数をvirtual textて表示
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
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  keys = {
    { "zr", function() require('ufo').openAllFolds() end, mode = "n" },
    { "zm", function() require('ufo').closeAllFolds() end, mode = "n" },
    { "zn", function() require('ufo').peekFoldedLinesUnderCursor() end, mode = "n" },
  },
  config = function()
    vim.api.nvim_set_option("fillchars", [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]])
    vim.api.nvim_set_option("foldcolumn", "2")
    vim.api.nvim_set_option("foldlevel", 99)
    vim.api.nvim_set_option("foldlevelstart", 99)
    vim.api.nvim_set_option("foldenable", true)
    require("ufo").setup({
      open_fold_hl_timeout = 150,
      close_fold_kinds = { "imports", "comment" },
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
        -- return ftMap[filetype]
      end,
    })
  end
}
