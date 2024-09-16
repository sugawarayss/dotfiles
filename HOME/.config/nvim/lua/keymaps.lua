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
u.keymap("n", "ss", ":split<Return><C-w>w", opts)
-- ウィンドウを垂直分割(左右)
u.keymap("n", "sv", ":vsplit<Return><C-w>w", opts)

-- ウィンドウ移動(左下上右)
u.keymap("n", "sh", "<C-w>h", opts)
u.keymap("n", "sj", "<C-w>j", opts)
u.keymap("n", "sk", "<C-w>k", opts)
u.keymap("n", "sl", "<C-w>l", opts)

-- 新しいタブを一番右に作る
u.keymap("n", "gn", ":tabnew<Return>", opts)
-- タブ移動(左右)
u.keymap("n", "gh", "gT", opts)
u.keymap("n", "gl", "gt", opts)

for i = 1, 9 do
  u.keymap("n", "<leader>"..i, i.."gt", opts)
end

-----------------------------
---        編集系         ---
-----------------------------
-- 行末までのヤンクにする(neovimはデフォルトで行末までヤンク)
-- u.keymap("n", "Y", "y$", opts)

-- U で Redo 
u.keymap("n", "U", "<C-r>", opts)

-- ESC*2 でハイライトやめる
u.keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", opts)

-- インサートモード時、jjでノーマルモードに移行
u.keymap("i", "jj", "<ESC>", opts)

-- インサートモードのままカーソル移動
-- Ctrl+fで一つ右へ移動
u.keymap("i", "<C-f>", "<C-g>U<Right>", opts)
-- Ctrl+f Ctrl+fで一番外へ移動
u.keymap("i", "<C-f><C-f>", "<C-g>U<Esc><S-a>", opts)

-- 行を上下に移動
-- u.keymap("n", "<M-k>", "$'<Cmd>move-1-{v:count1}<CR>=l'")
-- u.keymap("n", "<M-j>", "$'<Cmd>move+{v:count1}<CR>=l'")

-- M で括弧ジャンプ
u.keymap("n", "<S-m>", "%")

-- 入力してから大文字を切り替え
u.keymap("i", "<C-g><C-u>", "<ESC>gUiwgi", opts)
-- 入力してから小文字を切り替え
u.keymap("i", "<C-g><C-l>", "<ESC>guiwgi", opts)
-- 先頭の文字だけ大文字に切り替え
u.keymap("i", "<C-g><C-w>", "<ESC>bgUlgi", opts)

-----------------------------
---      スクロール       ---
-----------------------------
-- 検索結果を画面中央に持ってくる
u.keymap("n", "n", "nzz", opts)
u.keymap("n", "N", "Nzz", opts)
-- カーソル上の単語を検索して移動時
u.keymap("n", "*", "*zz", opts)
u.keymap("n", "#", "#zz", opts)

u.keymap("n", "g*", "g*zz", opts)
u.keymap("n", "g#", "g#zz", opts)


-----------------------------
---         Visual        ---
-----------------------------
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
