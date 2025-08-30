if vim.g.vscode then
  return {}
else
  -- MCPサーバを管理するプラグイン
  return {
    "ravitemer/mcphub.nvim",
    enabled = true,
    cmd = "MCPHub",
    -- build = "npm install -g mcp-hub@latest",
    build = "bundled_build.lua",
    config = function()
      require("mcphub").setup({
        -- MCPサーバ設定ファイルへの絶対パス
        -- config = vim.fn.expand("~/.config/mcphub/servers.json"),
        -- mcp-hubサーバがlistenするポート番号
        port = 37373,
        -- Neovimインスタンスが終了した後、MCPサーバを停止するまでの待機時間
        shutdown_delay = 600000,
        -- バンドルバイナリを使用する(build="bundled_build.lua"を使用する際は設定必須)
        use_bundled_binary = true, -- userlocal `mcp-hub` binary
        -- MCPツールの実行時に許容する最大待機時間(ミリ秒)
        mcp_request_timeout = 60000,
        -- MCPHubによって起動されたすべてのMCPサーバにセットする環境変数
        global_env = {},
        -- プロジェクトローカル構成を有効にする
        workspace = {
          -- ワークスペース機能のマスタースイッチ
          enabled = true,
          -- プロジェクト境界を検出するときに基準とするファイル
          look_for = { ".mcphub/servers.json", ".vscode/mcp.json", ".cursor/mcp.json" },
          -- ディレクトリ変更時にハブを自動切替
          reload_on_dir_changed = true,
          -- 一意にワークスペースポートを生成するためのポート範囲
          port_range = { min = 40000, max = 41000 },
          -- カスタムポート番号を返すオプション関数
          get_port = nil,
        },
        -- チャットプラグイン関連オプション
        -- LLMがMCPサーバ上のツールまたはリソースを呼び出しを自動的に承認する
        auto_approve = true,
        -- LLM が必要に応じてMCPサーバを自動的に起動/停止できるようにする
        auto_toggle_mcp_servers = true,
        extentions = {},
        native_servers = {},
        builtin_tools = {
          edit_file = {
            parser = {
              track_issues = true,
              extract_inline_content = true,
            },
            locator = {
              fuzzy_threshold = 0.8,
              enable_fuzzy_matching = true,
            },
            ui = {
              got_to_origin_on_complete = true,
              keybindings = {
                accept = ".",
                reject = ",",
                next = "n",
                prev = "p",
                accept_all = "ga",
                reject_all = "gr",
              },
            },
          },
        },
        ui = {
          window = {
            width = 0.8,
            height = 0.8,
            align = "center",
            relative = "editor",
            zindex = 50,
            border = "rounded",
          },
          wo = {
            winhl = "Normal:MCPHubNormal,FloatBorder:MCPhubBorder",
          },
        },
        -- 設定ファイル用のカスタムjsonパーサ関数
        json_decode = nil,
        on_ready = function(hub)
          vim.notify("MCPHub has ready")
          -- dd(hub)
        end,
        on_error = function(err)
          vim.notify("MCPHub error occurred")
          vim.print(err)
        end,
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        },
      })
    end,
  }
end
