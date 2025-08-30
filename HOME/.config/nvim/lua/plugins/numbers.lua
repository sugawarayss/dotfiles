-- Insert Mode時に絶対行表示にする
return {
  "myusuf3/numbers.vim",
  -- 遅延読み込みする
  lazy = true,
  -- Insert Mode時に絶対行表示にする
  event = { "InsertEnter" },
  config = function()
    vim.g.numbers_exclude = {
      -- snacks.nvim のピッカーには表示しない
      "snacks_picker_list",
      "snacks_terminal",
      "snacks_dashboard",
    }
  end,
}
