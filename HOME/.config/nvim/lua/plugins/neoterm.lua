-- TUIツールは画面全体で使うため、全画面で開いてから実行する
-- NOTE: neotermのウィンドウが既に開いている場合はその位置のまま実行される
local function run_fullscreen(command)
  local neoterm = require("neoterm")
  neoterm.open({ position = "fullscreen" })
  neoterm.run(command, { clear = false })
end

return {
  "itmecho/neoterm.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  cmd = { "NeotermToggle", "NeotermOpen", "NeotermRun", "NeotermRerun" },
  init = function()
    local wk = require("which-key")
    wk.add({
      {
        "<F3>6", -- 6: h
        function()
          require("neoterm").open({ position = "left" })
        end,
        mode = "n",
        desc = "[Neoterm] ターミナルウィンドウ(左)",
      },
      {
        "<F3>7", -- 7: j
        function()
          require("neoterm").open({ position = "bottom" })
        end,
        mode = "n",
        desc = "[Neoterm] ターミナルウィンドウ(下)",
      },
      {
        "<F3>8", -- 8: k
        function()
          require("neoterm").open({ position = "top" })
        end,
        mode = "n",
        desc = "[Neoterm] ターミナルウィンドウ(上)",
      },
      {
        "<F3>9", -- 9: l
        function()
          require("neoterm").open({ position = "right" })
        end,
        mode = "n",
        desc = "[Neoterm] ターミナルウィンドウ(右)",
      },
      {
        "<F3><F3>",
        function()
          require("neoterm").open({ position = "bottom" })
        end,
        mode = "n",
        desc = "[Neoterm] ターミナルウィンドウ",
      },
      {
        "<F3><F5>",
        function()
          require("neoterm").open({ position = "fullscreen" })
        end,
        mode = "n",
        desc = "[Neoterm] ターミナルウィンドウ(フルスクリーン)",
      },
      {
        "<leader>gq",
        function()
          run_fullscreen("lazysql")
        end,
        mode = "n",
        desc = "[Neoterm] Lazysqlを起動",
      },
      {
        "<leader>gs",
        function()
          run_fullscreen("slumber")
        end,
        mode = "n",
        desc = "[Neoterm] Slumber(HTTPクライアント)を起動",
      },
      {
        "<F3><F3>",
        "<Cmd>NeotermExit<CR>",
        mode = "t",
        desc = "[Neoterm] ターミナルウィンドウを閉じる",
      },
      {
        "<F3>n",
        "<C-\\><C-n>",
        mode = "t",
        desc = "[Neoterm] ターミナルモードからNORMALモードに戻る",
      },
    })
  end,
  config = function()
    require("neoterm").setup({
      -- コマンド実行前にclearを実行する
      clear_on_run = true,
      -- ターミナルの表示位置(fullscreen(0)|top(1)|right(2)|bottom(3)|left(4)|center(5))
      position = "center",
      -- ターミナルに入る時にINSERTモードにする
      noinsert = false,
      -- ターミナルウィンドウの幅の割合(0-1)
      width = 0.4,
      -- ターミナルウィンドウの縦幅の割合(0-1)
      height = 0.4,
    })
  end,
}
