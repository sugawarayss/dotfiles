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

glide.keymaps.set("normal", "<space>cr", "config_reload");
// Shift + Command + c で URL コピー
glide.keymaps.set("normal", "<S-D-c>", "url_yank");
// Shift + h, Shift + l でタブ移動
glide.keymaps.set("normal", "<S-h>", "tab_next");
glide.keymaps.set("normal", "<S-l>", "tab_prev");
