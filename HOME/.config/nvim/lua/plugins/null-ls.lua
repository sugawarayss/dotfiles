local cspell_config_dir = "~/.config/scpell"
local cspell_data_dir = "~/.local/share/cspell"
local cspell_files = {
  config = vim.call("expand", cspell_config_dir .. "/cspell.json"),
  dotfiles = vim.call("expand", cspell_config_dir .. "/dotfiles.txt"),
  vim = vim.call("expand", cspell_data_dir .. "/vim.txt.gz"),
  user = vim.call("expand", cspell_data_dir .. "/user.txt"),
}
-- vim辞書がなければダウンロード
if vim.fn.filereadable(cspell_files.vim) ~= 1 then
  local vim_dictionary_url = "https://github.com/iamcco/coc-spell-checker/raw/master/dicts/vim/vim.txt.gz"
  io.popen("curl -fsSLo " .. cspell_files.vim .. " --create-dirs " .. vim_dictionary_url)
end

-- ユーザ辞書が無ければ作成する
if vim.fn.filereadable(cspell_files.user) ~= 1 then
  io.popen("mkdir -p " .. cspell_data_dir)
  io.popen("touch " .. cspell_files.user)
end

-- 辞書に単語を追加するcommand
local cspell_append = function(opts)
  local word = opts.args
  if not word or word == "" then
    word = vim.call("expand", "<cword>"):lower()
  end
  -- bangの有無で保存先を分岐
  local dictionary_name = opts.bang and "dotfiles" or "user"
  io.popen("echo " .. word .. " >> " .. cspell_files[dictionary_name])
  -- 追加した単語および辞書を表示
  vim.notify(
    '"' .. word .. '" is appended to ' .. dictionary_name .. ' dictionary.',
    vim.log.levels.INFO,
    {}
  )
  -- cspellをリロードするため、現在行を更新してすぐ戻す
  if vim.api.nvim_get_option_value("modifiable", {}) then
    vim.api.nvim_set_current_line(vim.api.nvim_get_current_line())
    vim.api.nvim_command("silent! undo")
  end
end

vim.api.nvim_create_user_command(
  "CSpellAppend",
  cspell_append,
  { nargs = "?", bang = true }
)


-- LinterやFormatterを統合するプラグイン
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  lazy = true,
  event = "LspAttach",
  config = function()
    local null_ls = require("null-ls")
    local sources = {
      -- cspell(スペルチェック)
      null_ls.builtins.diagnostics.cspell.with({
        diagnostics_postprocess = function(diagnostics)
          -- レベルをWARNに変更
          diagnostics.severity = vim.diagnostic.severity["WARN"]
        end,
        condition = function()
          -- cspellが実行できるときのみ有効
          return vim.fn.executable("cspell") > 0
        end,
        diagnostics_format = '[cspell] #{s} (#{c}) #{m}',
        extra_args = { "--config", "~/.config/cspell/cspell.json" }
      }),
      -- python
      -- null_ls.builtins.formatting.black.with({
      --   filetypes = { "python" },
      --   extra_args = { "--config", "./pyproject.toml" }
      -- }),
      require("none-ls.formatting.ruff").with({
        filetypes = { "python" },
        extra_args = vim.fn.filereadable("./pyproject.toml") == 1 and { "--config", "./pyproject.toml" }
      }),
      null_ls.builtins.diagnostics.mypy.with({
        filetypes = { "python" },
        diagnostics_format = '[#{s}] (#{c}) #{m}',
        extra_args = vim.fn.filereadable("./pyproject.toml") == 1 and { "--config-file", "./pyproject.toml" }
      }),

      require("none-ls.diagnostics.ruff").with({
        filetypes = { "python" },
        diagnostics_format = '[#{s}] (#{c}) #{m}',
        extra_args = vim.fn.filereadable("./pyproject.toml") == 1 and { "--config", "./pyproject.toml" } or nil
      }),
      -- markdown
      null_ls.builtins.diagnostics.markdownlint.with({
        filetypes = { "markdown" },
        diagnostics_format = "[#{s}] (#{c}) #{m}",
      }),
      -- Lua
      null_ls.builtins.formatting.stylua.with({
        filetypes = { "lua" },
        extra_args = { "--config-path", "./stylua.toml" }
      }),
      -- Golang
      null_ls.builtins.formatting.gofumpt.with({
        filetypes = { "go" }
      }),
      null_ls.builtins.formatting.goimports.with({
        filetypes = { "go" }
      }),
      null_ls.builtins.formatting.biome.with({
        filetypes = { "javascript", "typescript", "jsx", "html", "css", "scss", "markdown" },
        extra_args = { "--config", "./biome.config.js" }
      }),
    }

    -- 辞書に単語を追加するcommandをCode Actionとして呼び出せるようにする
    local cspell_custom_actions = {
      name = 'append-to-cspell-dictionary',
      method = null_ls.methods.CODE_ACTION,
      filetypes = {},
      generator = {
        fn = function(_)
          -- 現在のカーソル位置
          local lnum = vim.fn.getcurpos()[2] - 1
          local col = vim.fn.getcurpos()[3]

          -- 現在行のエラーメッセージ一覧
          local diagnostics = vim.diagnostic.get(0, { lnum = lnum })

          -- カーソル位置にcspellの警告が出ているか探索
          local word = ''
          local regex = '^Unknown word %((%w+)%)$'
          for _, v in pairs(diagnostics) do
            if v.source == "cspell" and
                v.col < col and col <= v.end_col and
                string.match(v.message, regex) then
          -- 見つかった場合、単語を抽出
              word = string.gsub(v.message, regex, '%1'):lower()
              break
            end
          end

          -- 警告が見つからなければ終了
          if word == '' then
            return
          end

          -- cspell_appendを呼び出すactionのリストを返却
          return {
            {
              title = 'Append "' .. word .. '" to user dictionary',
              action = function()
                cspell_append({ args = word })
              end
            },
            {
              title = 'Append "' .. word .. '" to dotfiles dictionary',
              action = function()
                cspell_append({ args = word, bang = true })
              end
            }
          }
        end
      }
    }

    null_ls.register(cspell_custom_actions)

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    null_ls.setup({
      sources = sources,
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                  bufnr = bufnr,
                  filter = function(client)
                    return client.name == "null-ls"
                  end,
              })
            end,
          })
        end
      end,
    })
  end
}
