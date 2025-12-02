-- Insert Mode時に絶対行表示にする
return {
  "sitiom/nvim-numbertoggle",
  event = { "BufReadPost", "BufNewFile" },
}
