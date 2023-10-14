-- Language Serverの進捗を右下に表示する
return {
  "j-hui/fidget.nvim",
  tag="legacy",
  config = function()
    require("fidget").setup({
      options = {
        text = {
          spiner = "dots_pulse"
        }
      }
    })
  end
}
