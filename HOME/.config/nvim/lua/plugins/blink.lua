-- 補完プラグイン
return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    init = function()
      -- 補完ウィンドウの枠
      vim.opt.winborder = "rounded"
    end,
    opts = {
      -- 補完ソース
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      snnipets = { preset = "luasnip" },
      -- キーマップ
      keymap = {
        -- prese: "enter" のキーマップ
        -- INFO: https://cmp.saghen.dev/configuration/keymap.html#enter
        -- disableにする場合は false or {} を代入する
        preset = "enter",
        -- 補完ウィンドウの表示/ドキュメントの表示/非表示
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        -- 補完ウィンドウの非表示
        ["<C-e>"] = { "hide", "fallback" },
        -- 補完の確定
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "fallback" },
        ["<S-Tab>"] = { "fallback" },
        -- 補完候補の選択
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },
        -- ドキュメントスクロール
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        -- シグネチャヘルプの表示/非表示
        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      },
      -- 外観のカスタマイズ
      appearance = {
        nerd_font_variant = "mono",
      },
      -- 動作のカスタマイズ
      completion = {
        -- 補完候補のドキュメント表示
        documentation = { auto_show = true },
        -- 補完候補の表示内容
        menu = {
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
            components = {
              source_name = {
                text = function(ctx)
                  return "[" .. ctx.source_name .. "]"
                end,
              },
            },
          },
        },
      },
      signature = { enabled = true },
      fuzzy = {
        -- versionを指定してないとバイナリが特定できずLuaにfallbackするwarningが表示される
        implementation = "prefer_rust_with_warning",
      },
      -- terminalでの補完
      term = {
        -- INFO: nvim 0.11+ required
        enabled = true,
      },
    },
    opts_extend = { "sources.default" },
  },
  -- { "Kaiser-Yang/blink-cmp-dictionary" },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function()
      vim.keymap.set("n", "<C-s><C-s>", function()
        require("luasnip.loaders").edit_snippet_files()
      end, { desc = "スニペットを編集" })
      require("luasnip.loaders/from_vscode").lazy_load({
        paths = { "./snippets" },
      })
    end,
  },
}
