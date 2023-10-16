return {
  {
    "petertriho/nvim-scrollbar",
    lazy = true,
    event = { "BufReadPre" },
    dependencies = "kevinhwang91/nvim-hlslens",
    config = function()
      local mocha = require("catppuccin.palettes").get_palette "mocha"
      require("scrollbar").setup({
        handle = {
          color = mocha.surface2,
        },
        marks = {
          Search = { color = mocha.rosewater},
          Error = { color = mocha.red },
          Warn = { color = mocha.yellow },
          Info = { color = mocha.green },
          Hint = { color = mocha.sapphire },
          Misc = { color = mocha.lavender},
        },
        handlers = {
          search = true
        }
      })
    end
  },
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
