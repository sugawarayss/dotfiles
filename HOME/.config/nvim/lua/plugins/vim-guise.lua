-- NeoVim 内でNeoVimを開いたら、ネストせずタブで開くプラグイン
return {
  "lambdalisue/vim-guise",
  cond = function()
    return not vim.g.vscode
  end,
  event = "VimEnter",
}
