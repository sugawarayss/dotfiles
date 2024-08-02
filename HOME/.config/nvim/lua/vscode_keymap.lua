if vim.g.vscode then
  -- 開いているプロジェクト内のファイルを検索する
  -- ほかのVSCodeAPI はhttps://github.com/vscode-neovim/vscode-neovim/blob/319552f7aef9fd3a7b7e6dd4e3de5edaaee7c310/runtime/vscode/overrides/vscode-window-commands.vim あたりから探す
  vim.keymap.set("n", "<Leader>o", "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>")
  vim.keymap.set("n", "H", "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
  vim.keymap.set("n", "L", "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")
end
