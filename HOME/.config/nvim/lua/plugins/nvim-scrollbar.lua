-- スクロールバー拡張
return {
  {
    "petertriho/nvim-scrollbar",
    lazy = true,
    event = { "BufReadPre" },
    dependencies = "kevinhwang91/nvim-hlslens",
    config = function()
      local color_palette = require("hybrid.colors").setup()
      require("scrollbar").setup({
        handle = {
          color = color_palette.bg_hard,  -- "#151718"
        },
        marks = {
          Search = { color = color_palette.bright_cyan },  -- "#70c0b1"
          Error = { color = color_palette.bright_red },    -- "#d54e53",
          Warn = { color = color_palette.bright_yellow },  -- "#de935f"
          Info = { color = color_palette.bright_green },   -- "#8c9440"
          Hint = { color = color_palette.bright_blue },    -- "#5f819d"
          Misc = { color = color_palette.bright_magenta }, -- "#c397d8"
        },
        handlers = {
          search = true
        }
      })
    end
  },
-- 検索結果をvirtual textで表示するプラグイン
  {
    "kevinhwang91/nvim-hlslens",
    lazy = true,
    event = { "BufReadPre" },
    config = function()
      require("hlslens").setup({
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

          local lnum, col = unpack(posList[idx])
          if nearest then
            local cnt = #posList
            if indicator ~= "" then
              text = ('[%s %d/%s]'):format(indicator, idx, cnt)
            else
              text = ('[%d/%d]'):format(idx, cnt)
            end
            chunks = {{" ", "Ignore"}, {text, "HLSearchLensNear"}}
          else
            text = ('[%s %d]'):format(indicator, idx)
            chunks = {{' ', 'Ignore'}, {text, 'HLSearchLens'}}
          end
          render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
        end
      })
    end
  }
}
