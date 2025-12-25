-- 検索結果をvirtual textで表示するプラグイン
return {
  "kevinhwang91/nvim-hlslens",
  enabled = true,
  lazy = true,
  event = { "BufReadPost" },
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
    require("hlslens").setup({
      -- 検索結果に対してvirtual text (例[▼ 1/5] )を表示する設定
      override_lens = function(render, posList, nearest, idx, relIdx)
        local sfw = vim.v.searchforward == 1
        local indicator, text, chunks
        local absRelIdx = math.abs(relIdx)
        if absRelIdx > 1 then
          indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "▲" or "▼")
        elseif absRelIdx == 1 then
          indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
        else
          indicator = ""
        end

        -- lua 5.1と5.2+の互換のため
        local unpck = unpack or table.unpack
        local lnum, col = unpck(posList[idx])
        if nearest then
          local cnt = #posList
          if indicator ~= "" then
            text = ("[%s %d/%s]"):format(indicator, idx, cnt)
          else
            text = ("[%d/%d]"):format(idx, cnt)
          end
          chunks = { { " " }, { text, "HLSearchLensNear" } }
        else
          text = ("[%s %d]"):format(indicator, idx)
          chunks = { { " " }, { text, "HLSearchLens" } }
        end
        render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
      end,
      -- nvim-scrollbar に検索位置を表示する設定
      build_position_cb = function(plist, _, _, _)
        require("scrollbar.handlers.search").handler.show(plist.start_pos)
      end,
    })
  end,
}
