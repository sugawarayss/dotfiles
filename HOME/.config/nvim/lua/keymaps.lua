local u = require("utils")
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

--local keymap = vim.keymap
-- local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
u.keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

-----------------------------
----  Window/Tab 操作系  ----
-----------------------------
-- ウィンドウを水平分割(上下)
u.keymap("n", "ssk", ":leftabove split<Return>", { desc = "上に水平分割" })
u.keymap("n", "ssj", ":rightbelow split<Return>", { desc = "下に水平分割" })
-- ウィンドウを垂分割(左右)
u.keymap("n", "svh", ":leftabove vsplit<Return>", { desc = "左に垂直分割" })
u.keymap("n", "svl", ":rightbelow vsplit<Return>", { desc = "右に垂直分割" })

-- ウィンドウ移動(左下上右)
u.keymap("n", "sh", "<C-w>h", { desc = "左のバッファへフォーカスを移動" })
u.keymap("n", "sj", "<C-w>j", { desc = "下のバッファへフォーカスを移動" })
u.keymap("n", "sk", "<C-w>k", { desc = "上のバッファへフォーカスを移動" })
u.keymap("n", "sl", "<C-w>l", { desc = "右のバッファへフォーカスを移動" })

-- 新しいタブを一番右に作る
u.keymap("n", "gn", ":tabnew<Return>", { desc = "新しいタブを作成" })
-- タブ移動(左右)
u.keymap("n", "gh", "gT", { desc = "左のタブへ移動" })
u.keymap("n", "gl", "gt", { desc = "右のタブへ移動" })

for i = 1, 9 do
  u.keymap("n", "<leader>"..i, i.."gt", { desc = "タブ"..i.."へ移動" })
end

-----------------------------
---        編集系         ---
-----------------------------
-- 行末までのヤンクにする(neovimはデフォルトで行末までヤンク)
-- u.keymap("n", "Y", "y$", opts)

-- レジスタに入れずにカット
-- u.keymap("n", "x", "\"_d", opts)
u.keymap("n", "X", "\"_D", { desc = "行末までカット" })
u.keymap("x", "x", "\"_x", { desc = "選択範囲をカット" })
u.keymap("o", "x", "d", { desc = "選択範囲をカット" })


-- U で Redo 
u.keymap("n", "U", "<C-r>", { desc = "Redo" })

-- ESC*2 でハイライトやめる
u.keymap("n", "<Esc><Esc>", ":nohlsearch<CR>", { desc = "ハイライトをやめる" })

-- インサートモード時、jjでノーマルモードに移行
u.keymap("i", "jj", "<ESC>", { desc = "ノーマルモードに移行" })

-- インサートモードのままカーソル移動
-- Ctrl+fで一つ右へ移動
u.keymap("i", "<C-f>", "<C-g>U<Right>", { desc = "インサートモードのままカーソルを右へ移動" })
-- Ctrl+f Ctrl+fで一番外へ移動
u.keymap("i", "<C-f><C-f>", "<C-g>U<Esc><S-a>", { desc = "インサートモードのままカーソルを右へ移動" })

-- 行を上下に移動
-- u.keymap("n", "<S-k>", "$'<Cmd>move-1-{v:count1}<CR>=l'")
-- u.keymap("n", "<S-j>", "$'<Cmd>move+{v:count1}<CR>=l'")

-- M で括弧ジャンプ
u.keymap("n", "<S-m>", "%")

-- 入力してから大文字を切り替え
u.keymap("i", "<C-g><C-u>", "<ESC>gUiwgi", { desc = "入力してから大文字を切り替え" })
-- 入力してから小文字を切り替え
u.keymap("i", "<C-g><C-l>", "<ESC>guiwgi", { desc = "入力してから小文字を切り替え" })
-- 先頭の文字だけ大文字に切り替え
u.keymap("i", "<C-g><C-w>", "<ESC>bgUlgi", { desc = "先頭の文字だけ大文字に切り替え" })

-----------------------------
---      スクロール       ---
-----------------------------
-- 検索結果を画面中央に持ってくる
-- u.keymap("n", "n", "nzz", opts)
-- u.keymap("n", "N", "Nzz", opts)
-- カーソル上の単語を検索して移動時
u.keymap("n", "*", "*zz", { desc = "カーソル上の単語を検索して移動" })
u.keymap("n", "#", "#zz", { desc = "カーソル上の単語を検索して移動" })

u.keymap("n", "g*", "g*zz", { desc = "カーソル上の単語を検索して移動" })
u.keymap("n", "g#", "g#zz", { desc = "カーソル上の単語を検索して移動" })

-----------------------------
---         Visual        ---
-----------------------------
-- 連続ペーストできるように ペーストしても無名レジスタを更新させない
u.keymap("x", "p", "P", opts)

-- スペースに挟まれた範囲(WORD単位)を選択
u.keymap("o", "i<space>", "iW")
u.keymap("x", "i<space>", "iW")

-- visualモードで選択した範囲をインデントしてもvisualモードを維持する
u.keymap("v", "<", "<gv", opts)
u.keymap("v", ">", ">gv", opts)

-- visualモード時vで行末まで選択
u.keymap("v", "v", "$h", opts)

-- visualモードでヤンク時にカーソルが始点に飛ばないようにする
u.keymap("x", "y", "mzy`z", opts)

-- visualモードで選択範囲ごと上下に移動できるようにする
u.keymap("v", "<S-K>", ":move '<-2<CR>gv-gv", opts)
u.keymap("v", "<S-J>", ":move '>+1<CR>gv-gv", opts)
