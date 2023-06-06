vim.keymap.set("i", "<C-j>", "<Plug>(skkeleton-toggle)")
vim.keymap.set("c", "<C-j>", "<Plug>(skkeleton-toggle)")

local dictionaries = {}
local handle = io.popen("ls $HOME/.skk/*")
if handle then
  for file in handle:lines() do
    table.insert(dictionaries, {file, "euc-jp"})
  end
  handle:close()
end

vim.api.nvim_create_autocmd("User", {
  pattern = "skkeleton-initialize-pre",
  callback = function()
    print("callback")
    vim.fn["skkeleton#config"]({
      eggLikeNewline = true, -- 変換モードで改行キーを押した際に確定のみを行う
      registerConvertResult = true, -- カタカナ変換結果を辞書に登録する
      globalDictionaries = dictionaries, -- グローバル辞書を指定
    })
  end,
})

