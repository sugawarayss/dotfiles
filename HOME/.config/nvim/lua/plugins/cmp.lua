-- 自動補完プラグイン
return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },  -- LSP補完
      { "hrsh7th/cmp-buffer" },  -- バッファ補完
      { "hrsh7th/cmp-path" },  -- パス補完
      { "hrsh7th/vim-vsnip" },  -- スニペット補完
      { "onsails/lspkind.nvim" },
      { "windwp/nvim-autopairs" },
      { "zbirenbaum/copilot-cmp" },  -- Github copilotからの補完
    },
    config = function()
      local cmp = require("cmp")
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local lspkind = require('lspkind')

      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            -- maxwidth = 500,
            -- ellipsis_char = '...',
            menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[Latex]",
            }),
          })
        },
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,
        },
        window = {
          completion = {
            border = 'rounded',
            shadow = true,
          },
          documentation = {
            border = 'double',
            shadow = true,
          }
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' }, -- For vsnip users.
          -- { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          { name = 'buffer' },
          { name = 'path' },
          { name = 'copilot' },
        }),
        experimental = {
          ghost_text = true,
        }
      })
      -- on Edit CommitMessage
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          { name = 'buffer' },
        })
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        },
        {
          { name = "cmdline" }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })

      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        -- Default Config
        disable_filetype = {"TelescopePrompt", "spectre_panel"},
        disable_in_macro = true,
        disable_in_visualblock = false,
        disable_in_replace_mode = true,
        ignored_next_char  = [=[[%w%%%'%[%"%.%`%$]]=],
        enable_moveright = true,
        enable_afterquote = true,
        enable_check_bracket_line = true,
        enable_moveright_bracket_in_quote = true,
        enable_abbr = false,
        break_undo = true,
        check_ts = false,
        map_cr = true,
        map_bs = true,
        map_c_h = false,
        map_c_w = false,
      })
    end
  },
  -- Github Copilotのサジェストを補完リストに表示する
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup({
        suggestion = { enabled = true },
        panel = { enabled = true }
      })
    end
  }
}
