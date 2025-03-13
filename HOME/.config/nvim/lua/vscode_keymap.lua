if vim.g.vscode then
  -- 開いているプロジェクト内のファイルを検索する
  -- ほかのVSCodeAPIは https://github.com/vscode-neovim/vscode-neovim/blob/319552f7aef9fd3a7b7e6dd4e3de5edaaee7c310/runtime/vscode/overrides/vscode-window-commands.vim あたりから探す
  vim.keymap.set("n", "<Leader><Leader>", "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>")

  -- タブ移動
  vim.keymap.set("n", "H", "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
  vim.keymap.set("n", "L", "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")

  -- 画面の分割
  vim.keymap.set("n", "ssj", "<Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>")
  vim.keymap.set("n", "ssk", "<Cmd>call VSCodeNotify('workbench.action.splitEditorUp')<CR>")
  vim.keymap.set("n", "svl", "<Cmd>call VSCodeNotify('workbench.action.splitEditorRight')<CR>")
  vim.keymap.set("n", "svh", "<Cmd>call VSCodeNotify('workbench.action.splitEditorLeft')<CR>")


  -- 分割ペインのフォーカス移動
  vim.keymap.set("n", "sh", "<Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>")
  vim.keymap.set("n", "sl", "<Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>")
  vim.keymap.set("n", "sk", "<Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>")
  vim.keymap.set("n", "sj", "<Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>")

  -- 現在のタブのタブグループを移動(ペインを移動) FIXME: きかない!
  -- vim.keymap.set("n", "<C-s><C-l>", "<Cmd>call VSCodeNotify('workbench.action.moveEditorToRightGroup')<CR>")
  -- vim.keymap.set("n", "<C-s><C-h>", "<Cmd>call VSCodeNotify('workbench.action.moveEditorToLeftGroup')<CR>")
  -- vim.keymap.set("n", "<C-s><C-j>", "<Cmd>call VSCodeNotify('workbench.action.moveEditorToBelowGroup')<CR>")
  -- vim.keymap.set("n", "<C-s><C-k>", "<Cmd>call VSCodeNotify('workbench.action.moveEditorToAboveGroup')<CR>")
end
