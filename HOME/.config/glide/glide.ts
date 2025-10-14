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
glide.keymaps.set("normal", "<leader>f", "hint --location=browser-ui", {
  description: "ブラウザUIにヒントを表示",
});
glide.keymaps.set("normal", "f", "hint", { description: "画面内ヒントを表示" });
glide.keymaps.set("normal", "<C-o>", "jumplist_back", {
  description: "ジャンプリストを戻る",
});
glide.keymaps.set("normal", "<C-i>", "jumplist_forward", {
  description: "ジャンプリストを進む",
});

glide.keymaps.set("normal", "yy", "url_yank", {
  description: "現在のページURLをコピーする",
});
glide.keymaps.set("normal", "<S-D-c>", "url_yank", {
  description: "現在のページURLをコピーする",
});
glide.keymaps.set("normal", "<S-h>", "tab_next", {
  description: "次のタブを表示",
});
glide.keymaps.set("normal", "<S-l>", "tab_prev", {
  description: "前のタブを表示",
});
