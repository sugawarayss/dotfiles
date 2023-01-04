local options = {
    encoding = "utf-8",
    fileencoding = "utf-8",
    title = true,
    backup = false,
    clipboard = "unnamedplus",
    cmdheight = 2,
    completeopt = { "menuone", "noinsert" },
    conceallevel = 0,
    hlsearch = true,
    ignorecase = true,
    mouse = "a",
    pumheight = 10,
    showmode = false,
    showtabline = 2,
    smartcase = true,
    smartindent = true,
    swapfile = false,
    termguicolors = true,
    timeoutlen = 300,
    undofile = true,
    updatetime = 300,
    writebackup = false,
    shell = "zsh",
    backupskip = { "/tmp/*", "/private/tmp/*" },
    expandtab = true,
    shiftwidth = 2,
    tabstop = 4,
    cursorline = true,
    number = true,
    relativenumber = false,
    numberwidth = 4,
    signcolumn = "yes",
    wrap = false,
    winblend = 0,
    wildoptions = "pum",
    pumblend = 5,
    background = "dark",
    scrolloff = 8,
    sidescrolloff = 8,
    guifont = "Hack Nerd Font:h20",
    splitbelow = false, -- オンのとき、ウィンドウを横分割すると新しいウィンドウはカレントウィンドウの下に開かれる
    splitright = false, -- オンのとき、ウィンドウを縦分割すると新しいウィンドウはカレントウィンドウの右に開かれる
    pumblend = 10, -- pop upメニュー(補完時のポップアップ)を半透明にする
    winblend = 10, -- 任意のfloating windowを半透明にする
}

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]]) -- TODO: this doesn't seem to work
