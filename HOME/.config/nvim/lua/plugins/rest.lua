-- HTTP client for Neovim (like Postman)
return {
  "rest-nvim/rest.nvim",
  cmd = {
    "Rest",
  },
  config = function()
    local wk = require("which-key")
    wk.add({
      { "<Leader>ro", "<cmd>hor Rest open<CR>", mode = "n", icon = "󰖟", desc = "結果ペインを開く" },
      { "<Leader>rr", "<cmd>Rest run<CR>", mode = "n", icon = "󰖟", desc = "HTTP リクエストを送信" },
      { "<Leader>rla", "<cmd>Rest last<CR>", mode = "n", icon = "󰖟", desc = "最後に送信した HTTP リクエストを再送信" },
      { "<Leader>rlo", "<cmd>Rest logs<CR>", mode = "n", icon = "󰖟", desc = "HTTP リクエストのログを表示" },
      { "<Leader>rc", "<cmd>Rest cookies<CR>", mode = "n", icon = "󰖟", desc = "HTTP クッキーを編集" },
      { "<Leader>res", "<cmd>Telescope rest select_env<CR>", mode = "n", icon = "󰖟", desc = ".envファイルを選択して登録" },
      { "<Leader>rew", "<cmd>Rest env show<CR>", mode = "n", icon = "󰖟", desc = "登録されている.envファイルを表示" },
    })
  end,
}
