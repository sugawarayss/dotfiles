return {
  -- スクロールバー拡張
  {
    "petertriho/nvim-scrollbar",
    lazy = true,
    event = { "BufReadPre" },
    config = function()
      local color_palette = require("tokyonight.colors").setup()
      require("scrollbar").setup({
        show                = true,
        show_in_active_only = false,
        set_highlights      = true,
        folds               = 1000,
        max_lines           = false,
        hide_if_all_visible = false,
        throttle_ms         = 100,
        handle = {
          color = color_palette.bg_dark,  -- "#1f2335
        },
        marks = {
          Search = { color = color_palette.cyan },    -- #7dcfff
          Error  = { color = color_palette.red },     -- #f7768e
          Warn   = { color = color_palette.yellow },  -- #e0af68
          Info   = { color = color_palette.green },   -- #9ece6a
          Hint   = { color = color_palette.blue },    -- #7aa2f7
          Misc   = { color = color_palette.magenta }, -- #bb9af7
        },
        handlers = {
          cursor     = true,
          diagnostic = true,
          gitsigns   = true,
          search     = true
        }
      })
    end
  },
  -- 検索結果をvirtual textで表示するプラグイン
  {
    "kevinhwang91/nvim-hlslens",
    enabled = true,
    lazy = true,
    event = { "BufReadPre" },
    config = function()
      require("hlslens").setup({
        -- 検索結果に対してvirtual text (例[▼ 1/5] )を表示する設定
        override_lens = function(render, posList, nearest, idx, relIdx)
          if not vim.g.vscode then
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
              chunks = {{" "}, {text, "HLSearchLensNear"}}
            else
              text = ('[%s %d]'):format(indicator, idx)
              chunks = {{' '}, {text, 'HLSearchLens'}}
            end
            render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
          else
            print("disable hlslens virtual text in vscode")
          end
        end,
        -- nvim-scrollbar に検索位置を表示する設定
        build_position_cb = function(plist, _, _, _)
          require("scrollbar.handlers.search").handler.show(plist.start_pos)
        end
      })
    end
  }
}
