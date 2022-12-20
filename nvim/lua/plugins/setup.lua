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
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    -- vscode color scheme
    use ({ 'projekt0n/github-nvim-theme' })

    -- filer plugin
    use "lambdalisue/fern.vim"
    -- use Nerd Font
    use "lambdalisue/nerdfont.vim"
    -- display icons in filer
    use "lambdalisue/fern-renderer-nerdfont.vim"
    -- display git status in filer
    use "lambdalisue/fern-git-status.vim"

    -- Terminal Plugin
    use "kassio/neoterm"

    -- use deno
    use "vim-denops/denops.vim"

    -- dependency of telescope plugin
    use "nvim-lua/plenary.nvim"
    -- Fuzzy Finder
    use "nvim-telescope/telescope.nvim"
    -- 曖昧検索結果にアイコンを表示できるプラグイン
    use "kyazdani42/nvim-web-devicons"

    -- TODOコメントをハイライトするプラグイン
    use {"folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim"  }

    -- インデントを可視化するプラグイン
    use "lukas-reineke/indent-blankline.nvim"

    -- 括弧を自動で閉じるプラグイン
    use "windwp/nvim-autopairs"

    -- コードとテストコードのファイルを行き来できるプラグイン
    use "rgroli/other.nvim"

    -- 囲う系の操作を便利にするプラグイン
    use "tpope/vim-surround"

    -- markdownをプレビューできるプラグイン
    use {"iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]()  end}

    -- syntax highlight
    use "nvim-treesitter/nvim-treesitter"
    use "nvim-treesitter/playground"

    --  テキストを囲う操作を行えるようにするプラグイン
    use "machakann/vim-sandwich"
    --     saiw( : foo   → (foo)
    --     sd    : (foo) → foo
    --     sr    : (foo) → "foo"

    -- ステータスバーに色付けして表示するプラグイン
    use "itchyny/lightline.vim"
    -- ステータスバーにgitbranchを表示するプラグイン
    use "itchyny/vim-gitbranch"

    -- coc-vimと連携して関数や変数へジャンプできるプラグイン
    use "liuchengxu/vista.vim"
    -- vscodeの機能を使用できるようにするプラグイン
    use {"neoclide/coc.nvim", branch = 'release'}

    use "rktjmp/lush.nvim"

    -- inlineにgitblame等を表示するプラグイン
    use {'lewis6991/gitsigns.nvim', tag = 'release'}

    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
