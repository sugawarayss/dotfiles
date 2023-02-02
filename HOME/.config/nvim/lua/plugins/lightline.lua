vim.opt["laststatus"] = 2
vim.cmd([[
let g:lightline = {
  \ 'colorscheme': 'wombat', 
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'filename'] ], 
  \   'right': [ [ 'lineinfo', 'syntastic' ], [ 'percent' ], [ 'charcode', 'fileformat', 'fileconfig', 'filetype' ] ] 
  \ },
  \ 'inactive': {
  \   'left': [ [ 'filename' ] ], 
  \   'right': [ [ 'lineinfo' ], [ 'percent' ] ]
  \ }, 
  \ 'component_function': {
  \   'gitbranch': 'gitbranch#name'
  \ }
  \}
]])
