vim.cmd([[
let g:lightline = {
  \ 'colorscheme': 'wombat', 
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ], [ 'fugtive', 'gitgutter', 'filename'] ], 
  \   'right': [ [ 'lineinfo', 'syntastic' ], [ 'percent' ], [ 'charcode', 'fileformat', 'fileconfig', 'filetype' ] ] 
  \ },
  \ 'inactive': {
  \   'left': [ [ 'filename' ] ], 
  \   'right': [ [ 'lineinfo' ], [ 'percent' ] ]
  \ }
  \}
]])
