local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the setup.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost setup.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

vim.opt.guifont = { "Hack Nerd Font", "h20" }
packer.init {
  display = {
    open_fn = require("packer.util").float,
  },
}
return packer.startup(function(use)
  -- Packer (プラグイン管理) →自分自身も管理する
  use "wbthomason/packer.nvim"
  -- カラーテーマ
  --use "marko-cerovac/material.nvim"
  use "EdenEast/nightfox.nvim"
  -- focusがないペインを暗く表示する
  use "sunjon/shade.nvim"
  -- ファイラープラグイン
  use "lambdalisue/fern.vim"
  -- フォント
  use "lambdalisue/nerdfont.vim"
  -- ファイラーでNerdFontを使用できるようにする
  use "lambdalisue/fern-renderer-nerdfont.vim"
  -- ファイラーにgitステータスを表示する
  use "lambdalisue/fern-git-status.vim"
  -- ファイラーでファイルのプレビューを表示する
  use "yuki-yano/fern-preview.vim"
  -- タブごとに表示するバッファを切り替える
  use { 'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons' }
  -- バッファ領域にコマンドの出力結果を表示する
  use "tyru/capture.vim"
  -- LSP サーバ管理
  use {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/vim-vsnip",
    "hrsh7th/nvim-cmp",
    "onsails/lspkind.nvim"
  }
  use "j-hui/fidget.nvim"
  use "ray-x/lsp_signature.nvim"
  -- Language Server管理
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
  -- MasonでLinter / formatterを使用する
  use { "jay-babu/mason-null-ls.nvim", requires = "jose-elias-alvarez/null-ls.nvim" }
  -- ターミナルをpopupウィンドウで表示できるようにする
  use "voldikss/vim-floaterm"
  -- Vim コマンドラインを ウィンドウ右下に表示する
  --use {"VonHeikemen/fine-cmdline.nvim", requires = "MunifTanjim/nui.nvim"}
  use { "folke/noice.nvim", requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" } }
  -- denoを利用可能にする
  use "vim-denops/denops.vim"
  -- 翻訳プラグイン
  use "voldikss/vim-translator"
  -- IME
  use { "vim-skk/skkeleton", requires = { "vim-denops/denops.vim", "Shougo/ddc.vim" } }
  -- 曖昧検索できるようにする
  use { "nvim-telescope/telescope.nvim", requires = "nvim-lua/plenary.nvim" }
  use "nvim-telescope/telescope-ui-select.nvim"
  -- telescopeでチートシートを表示できる
  use { "sudormrfbin/cheatsheet.nvim", requires = { { "nvim-telescope/telescope.nvim" }, { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" }, } }
  -- telescopeでdockerを操作する
  use { "lpoto/telescope-docker.nvim" }
  -- 曖昧検索結果にアイコンを表示できるプラグイン
  use "kyazdani42/nvim-web-devicons"
  -- 一括コメントアウト
  use "tpope/vim-commentary"
  -- TODOコメントをハイライトするプラグイン
  use { "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" }
  -- インデントを可視化するプラグイン
  use "lukas-reineke/indent-blankline.nvim"
  -- 括弧を自動で閉じるプラグイン
  use "windwp/nvim-autopairs"
  -- 対応するキーワードや記号にジャンプできる
  use "andymass/vim-matchup"
  -- コードとテストコードのファイルを行き来できるプラグイン
  use "rgroli/other.nvim"
  -- 囲う系の操作を便利にするプラグイン
  use "kylechui/nvim-surround"
  -- コードアウトラインを表示する
  use "stevearc/aerial.nvim"
  -- markdownをプレビューできるプラグイン
  use {
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end
  }
  -- シンタックスハイライト
  use "nvim-treesitter/nvim-treesitter"
  use "nvim-treesitter/playground"
  --  テキストを囲う操作を行えるようにするプラグイン
  use "machakann/vim-sandwich"
  --     saiw( : foo   → (foo)
  --     sd    : (foo) → foo
  --     sr    : (foo) → "foo"
  -- Neovim上で直接Gitに関する操作を行うプラグイン
  use "dinhhuy258/git.nvim"
  -- ステータスバーに色付けして表示するプラグイン
  use "nvim-lualine/lualine.nvim"
  -- ステータスバーにgitbranchを表示するプラグイン
  use "itchyny/vim-gitbranch"
  -- inlineにgitblame等を表示するプラグイン
  use { "lewis6991/gitsigns.nvim", requires = "nvim-lua/plenary.nvim" }
  -- カラーコードを色付け
  use "norcalli/nvim-colorizer.lua"
  -- csvを色付け
  use "Decodetalkers/csv-tools.lua"
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
