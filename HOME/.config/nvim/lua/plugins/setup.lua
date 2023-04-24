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

vim.opt.guifont = { "Hack Nerd Font", "h20"}
return packer.startup(function(use)
    -- Packer (プラグイン管理) →自分自身も管理する
    use "wbthomason/packer.nvim"

    -- カラーテーマ
    use "marko-cerovac/material.nvim"

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

    -- ターミナルをpopupウィンドウで表示できるようにする
    use "voldikss/vim-floaterm"

    use "romgrk/barbar.nvim"

    -- Vim コマンドラインを ウィンドウ右下に表示する
    use {"VonHeikemen/fine-cmdline.nvim", requires = "MunifTanjim/nui.nvim"}

    -- denoを利用可能にする
    use "vim-denops/denops.vim"

    -- telescopeの依存プラグイン
    use "nvim-lua/plenary.nvim"

    -- 曖昧検索できるようにする
    use "nvim-telescope/telescope.nvim"

    -- telescopeからcocを扱えるようにする
    use "fannheyward/telescope-coc.nvim"

    -- 曖昧検索結果にアイコンを表示できるプラグイン
    use "kyazdani42/nvim-web-devicons"

    -- TODOコメントをハイライトするプラグイン
    use {"folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim"  }

    -- インデントを可視化するプラグイン
    use "lukas-reineke/indent-blankline.nvim"

    -- 括弧を自動で閉じるプラグイン
    use "windwp/nvim-autopairs"

    use "andymass/vim-matchup"

    -- コードとテストコードのファイルを行き来できるプラグイン
    use "rgroli/other.nvim"

    -- 囲う系の操作を便利にするプラグイン
    use "kylechui/nvim-surround"

    -- markdownをプレビューできるプラグイン
    use {"iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]()  end}

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

    -- coc-vimと連携して関数や変数へジャンプできるプラグイン
    use "liuchengxu/vista.vim"
    -- vscodeの機能を使用できるようにするプラグイン
    use {"neoclide/coc.nvim", branch = 'release'}

    use "rktjmp/lush.nvim"

    -- inlineにgitblame等を表示するプラグイン
    use "lewis6991/gitsigns.nvim"

    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
