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
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          cmdline = {
            -- コマンドラインへの入力が3文字未満の場合は補完を無効にする
            min_keyword_length = function(ctx)
              if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                return 3
              end
              return 0
            end,
          },
          copilot = {
            name = "Copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
            transform_items = function(_, items)
              local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = "Copilot"
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
          },
        },
      },
      snippets = { preset = "luasnip" },
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
        kind_icons = {
          Copilot = "",
        },
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
              -- 各補完候補の種類アイコン
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
                  end
                  return icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
              source_name = {
                text = function(ctx)
                  return "[" .. ctx.source_name .. "]"
                end,
              },
            },
          },
        },
        ghost_text = {
          -- 補完候補のゴーストテキスト表示
          enabled = false,
        },
      },
      signature = { enabled = false },
      fuzzy = {
        -- versionを指定してないとバイナリが特定できずLuaにfallbackするwarningが表示される
        implementation = "prefer_rust_with_warning",
      },
      -- command lineでの補完
      cmdline = {
        completion = {
          menu = { auto_show = true },
          ghost_text = { enabled = true },
        },
        keymap = {
          ["<Tab>"] = { "accept" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<Up>"] = { "select_prev", "fallback" },
        },
      },
      -- terminalでの補完
      term = {
        -- INFO: nvim 0.11+ required
        enabled = false,
      },
    },
    opts_extend = { "sources.default" },
  },
  { "giuxtaposition/blink-cmp-copilot" },
  { "onsails/lspkind.nvim", lazy = true },
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
