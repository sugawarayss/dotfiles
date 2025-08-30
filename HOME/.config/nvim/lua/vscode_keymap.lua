if vim.g.vscode then
  local vscode = require("vscode")
  -- 開いているプロジェクト内のファイルを検索する
  -- ほかのVSCodeAPIは https://github.com/vscode-neovim/vscode-neovim/blob/319552f7aef9fd3a7b7e6dd4e3de5edaaee7c310/runtime/vscode/overrides/vscode-window-commands.vim あたりから探す
  -- vim.keymap.set("n", "<Leader><Leader>", "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>")
  vim.keymap.set("n", "<Leader><Leader>", function()
    vscode.call("workbench.action.quickOpen")
  end)

  -- ファイルエクスプローラの表示
  -- vim.keymap.set("n", "<Leader>fe", "<Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>")
  vim.keymap.set("n", "<Leader>fe", function()
    vscode.call("workbench.action.toggleSidebarVisibility")
  end)

  -- タブ移動
  -- vim.keymap.set("n", "H", "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
  vim.keymap.set("n", "<S-H>", function()
    vscode.call("workbench.action.previousEditor")
  end)
  -- vim.keymap.set("n", "L", "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")
  vim.keymap.set("n", "<S-L>", function()
    vscode.call("workbench.action.nextEditor")
  end)

  -- 画面の分割
  -- vim.keymap.set("n", "<C-h>", "<Cmd>call VSCodeNotify('workbench.action.splitEditorLeft')<CR>")
  vim.keymap.set("n", "<C-h>", function()
    vscode.call("workbench.action.splitEditorLeft")
  end)
  -- vim.keymap.set("n", "<C-j>", "<Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>")
  vim.keymap.set("n", "<C-j>", function()
    vscode.call("workbench.action.splitEditorDown")
  end)
  -- vim.keymap.set("n", "<C-k>", "<Cmd>call VSCodeNotify('workbench.action.splitEditorUp')<CR>")
  vim.keymap.set("n", "<C-k>", function()
    vscode.call("workbench.action.splitEditorUp")
  end)
  vim.keymap.set("n", "<C-l>", "<Cmd>call VSCodeNotify('workbench.action.splitEditorRight')<CR>")

  -- 分割ペインのフォーカス移動(→VSCode側で設定)
  -- vim.keymap.set("n", "<M-h>", "<Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>")
  -- vim.keymap.set("n", "<M-j>", "<Cmd>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>")
  -- vim.keymap.set("n", "<M-k>", "<Cmd>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>")
  -- vim.keymap.set("n", "<M-l>", "<Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>")

  -- 現在のタブのタブグループを移動(→VSCode側で設定)
  -- vim.keymap.set("n", "<C-S-s>h", "<Cmd>call VSCodeNotify('workbench.action.moveEditorToLeftGroup')<CR>")
  -- vim.keymap.set("n", "<C-S-s>j", "<Cmd>call VSCodeNotify('workbench.action.moveEditorToBelowGroup')<CR>")
  -- vim.keymap.set("n", "<C-S-s>k", "<Cmd>call VSCodeNotify('workbench.action.moveEditorToAboveGroup')<CR>")
  -- vim.keymap.set("n", "<C-S-s>l", "<Cmd>call VSCodeNotify('workbench.action.moveEditorToRightGroup')<CR>")

  -- vim.keymap.set("n", "<F5>", "<Cmd>call VSCodeNotify('workbench.action.findInWorkspace')<CR>")

  -- Chat Pane のトグル
  -- vim.keymap.set("n", "<Leader>cc", "<Cmd>call VSCodeNotify('workbench.action.toggleAuxiliaryBar')<CR>")

  -- ブックマークのトグル
  -- vim.keymap.set("n", ";mm", "<Cmd>call VSCodeNotify('bookmarks.toggle')")
end
