// Config docs:
//
//   https://glide-browser.app/config
//
// API reference:
//
//   https://glide-browser.app/api
//
// Default config files can be found here:
//
//   https://github.com/glide-browser/glide/tree/main/src/glide/browser/base/content/plugins
//
// Most default keymappings are defined here:
//
//   https://github.com/glide-browser/glide/blob/main/src/glide/browser/base/content/plugins/keymaps.mts
//
// Try typing `glide.` and see what you can do!

// ヒントのフォントサイズを指定
glide.o.hint_size = "16px";

///////////////
/// keymaps ///
///////////////
glide.keymaps.set("normal", "<leader>r", "reload", {
  description: "画面をリロード",
});
glide.keymaps.set("normal", "<leader>R", "reload_hard", {
  description: "スーパーリロード",
});
glide.keymaps.set("normal", "<leader><leader>", "commandline_show tab", {
  description: "タブリストをコマンドラインで表示",
});
glide.keymaps.set("normal", "<leader>d", "tab_close", {
  description: "タブを閉じる",
});
glide.keymaps.set("normal", "gg", "scroll_top", {
  description: "下にスクロール",
});
glide.keymaps.set("normal", "G", "scroll_bottom", {
  description: "最下部にスクロール",
});
glide.keymaps.set(["normal", "insert"], "<C-d>", "scroll_page_down", {
  description: "ページを下にスクロール",
});
glide.keymaps.set(["normal", "insert"], "<C-u>", "scroll_page_up", {
  description: "ページを下にスクロール",
});
glide.keymaps.set("normal", "<leader>f", "hint --location=browser-ui", {
  description: "ブラウザUIにヒントを表示",
});
glide.keymaps.set("normal", "f", "hint", { description: "画面内ヒントを表示" });
glide.keymaps.set(["normal", "insert"], "<C-h>", "back", {
  description: "戻る",
});
glide.keymaps.set(["normal", "insert"], "<C-l>", "forward", {
  description: "進む",
});
glide.keymaps.set(["normal", "insert"], "<C-o>", "jumplist_back", {
  description: "ジャンプリストを戻る",
});
glide.keymaps.set(["normal", "insert"], "<C-i>", "jumplist_forward", {
  description: "ジャンプリストを進む",
});
glide.keymaps.set("normal", "yy", "url_yank", {
  description: "現在のページURLをコピーする",
});
glide.keymaps.set(["normal", "insert"], "<C-j>", "tab_next", {
  description: "次のタブを表示",
});
glide.keymaps.set(["normal", "insert"], "<C-k>", "tab_prev", {
  description: "前のタブを表示",
});
glide.keymaps.set("normal", "i", "mode_change insert --automove=left", {
  description: "インサートモード",
});
glide.keymaps.set("normal", "a", "mode_change insert", {
  description: "カーソルの直後にインサートモード",
});
glide.keymaps.set("normal", "A", "mode_change insert --automove=endline", {
  description: "行末にジャンプしてインサートモード",
});
glide.keymaps.set("normal", "u", "undo", { description: "アンドゥ" });

glide.keymaps.set("normal", ":", "commandline_show", {
  description: "コマンドラインモード",
});
glide.keymaps.set("normal", ".", "repeat", { description: "リピート" });
