-- 自動補完プラグイン
return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "f3fora/cmp-spell" }, -- 英語入力時のスペル補完ソース
      { "hrsh7th/cmp-nvim-lsp" }, -- LSP補完
      { "hrsh7th/cmp-buffer" }, -- バッファ補完
      { "hrsh7th/cmp-path" }, -- パス補完
      { "hrsh7th/cmp-cmdline" }, -- コマンドライン入力の補完ソース
      -- { "hrsh7th/vim-vsnip" },  -- スニペット補完
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        config = function()
          vim.keymap.set("n", "<C-s><C-s>", function()
            require("luasnip.loaders").edit_snippet_files()
          end, { desc = "スニペットを編集" })
          require("luasnip.loaders/from_vscode").lazy_load({ paths = { "./snippets" } })
        end,
      }, -- スニペットエンジン
      { "saadparwaiz1/cmp_luasnip" }, -- cmp と luasnip の連携
      { "onsails/lspkind.nvim" },
    },
    keys = {
      -- { "<C-s><C-s>", require("luasnip.loaders").edit_snippet_files, mode = "n", desc = "スニペットを編集" },
    },
    config = function()
      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")
      -- require("luasnip.loaders/from_vscode").lazy_load({ paths = {"./snippets"} })

      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            -- maxwidth = 500,
            -- ellipsis_char = "...",
            menu = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[Latex]",
              Copilot = "[Copilot]",
              path = "[Path]",
              cmdline = "[Cmdline]",
            },
          }),
        },
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
            -- require("snippy").expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,
        },
        window = {
          completion = {
            border = "rounded",
            shadow = true,
          },
          documentation = {
            border = "double",
            shadow = true,
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm({ select = true })
              end
            else
              fallback()
            end
          end),
          ["<Down>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<Up>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          -- { name = "vsnip" }, -- For vsnip users.
          { name = "luasnip", priority_weight = 20 }, -- For luasnip users.
          -- { name = "ultisnips" }, -- For ultisnips users.
          -- { name = "snippy" }, -- For snippy users.
        }, {
          { name = "buffer" },
          { name = "path" },
          -- { name = "cmdline"},
          {
            name = "spell",
            option = {
              keep_all_entries = false,
              enable_in_context = function()
                return true
              end,
              preselect_correct_word = true,
            },
          },
          { name = "copilot" },
        }),
        experimental = {
          ghost_text = true,
        },
      })
      -- on Edit CommitMessage
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          { name = "buffer" },
        }),
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })

      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  -- Github Copilotのサジェストを補完リストに表示する
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   config = function()
  --     require("copilot_cmp").setup({
  --       suggestion = { enabled = true },
  --       panel = { enabled = true }
  --     })
  --   end
  -- }
}
