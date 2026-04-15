-- Language Serverの進捗を右下に表示する

-- 長すぎるfidgetメッセージを整形するヘルパー関数
-- 文字列がパスかどうか判定します
local function isPath(inputString)
  return string.find(inputString, "[/\\]")
end

-- 文字列をスペースで分割します
local function splitString(inputString)
  local splittedStrings = {}
  for word in string.gmatch(inputString, "%S+") do
    table.insert(splittedStrings, word)
  end
  return splittedStrings
end

-- 文字列からパスを取り除きます
local function removePathFromString(inputString)
  local splittedStrings = splitString(inputString)

  local processedStrings = {}
  for _, word in ipairs(splittedStrings) do
    if not isPath(word) then
      table.insert(processedStrings, word)
    end
  end

  local processedString = ""
  for i, word in ipairs(processedStrings) do
    if i == #processedStrings then
      processedString = processedString .. word
    else
      processedString = processedString .. word .. " "
    end
  end

  return processedString
end

return {
  "j-hui/fidget.nvim",
  enabled = true,
  ops = {
    progress = {
      -- How and when to poll for progress messages
      poll_rate = 0,
      -- Suppress new messages while in insert mode
      suppress_on_insert = false,
      -- Ignore new tasks that are already complete
      ignore_done_already = false,
      -- Ignore new tasks that don't contain a message
      ignore_empty_message = false,
      -- Clear notification group when LSP server detaches
      clear_on_detach = function(client_id)
        local client = vim.lsp.get_client_by_id(client_id)
        return client and client.name or nil
      end,
      -- How to get a progress message's notification group key
      notification_group = function(msg)
        return msg.lsp_client.name
      end,
      -- List of LSP servers to ignore
      ignore = {},
      -- Options related to how LSP progress messages are displayed as notifications
      display = {
        -- How many LSP messages to show at once
        render_limit = 16,
        -- How log a message should persist  after completion
        done_ttl = 3,
        -- Icon shown when all LSP progress tasks are complete
        done_icon = "",
        -- Highlight group for in-progress LSP tasks
        done_style = "Constant",
        -- How long a message should persist when in progress
        progress_ttl = math.huge,
        -- Icon shown when LSP progress tasks are in progress
        progress_icon = { pattern = "clock", period = 2 },
        -- Highlight group for in-progress LSP tasks
        progress_style = "WarningMsg",
        -- Highlight group for group name (LSP server name)
        group_style = "Title",
        -- Highlight group for group icons
        icon_style = "Question",
        -- Ordering priority for LSP notification group
        priority = 30,
        -- Whether progress notifications should be omitted from history
        skip_history = true,
        format_message = function(msg)
          local message = ""
          if not msg.message then
            message = msg.done and "Completed" or "In Progress..."
          else
            message = removePathFromString(msg.message)
          end
          if msg.percentage ~= nil then
            message = string.format("%s (%.0f%%)", message, msg.percentage)
          end
          return message
        end,
        -- How to format a progress message
        format_annote = function(msg)
          return msg.title
        end,
        -- How to format a progress notification group's name
        format_group_name = function(group)
          return tostring(group)
        end,
        -- Override options from the default notification config
        overrides = {
          rust_analyzer = { name = "rust-analyzer" },
        },
      },
      -- Options related to Neovim's built-in LSP client
      lsp = {
        -- Configure the nvim's LSP progress ring buffer size
        progress_ringbuf_size = 0,
        -- Log `$/progress` handler invocations (for debugging)
        log_handler = false,
      },
    },
    -- Options related to notification subsystem
    notification = {
      -- How frequently to update and render notifications
      poll_rate = 10,
      -- Minimum notifications level
      filter = vim.log.levels.INFO,
      -- Number of removed messaged to retain in history
      history_size = 128,
      -- Automatically override vim.notify() with Fidget
      override_vim_notify = false,
      -- How to configure notification groups when instantiated
      -- configs = { default = require("fidget.notification").default_config },
      -- Conditionally redirect notifications to another backend
      redirect = function(msg, level, opts)
        if opts and opts.on_open then
          return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
        end
      end,
      -- Options related to how notifications are rendered as text
      view = {
        -- Display notification items from bottom to top
        stack_upwards = true,
        -- Indent messages longer than a single line
        align = "message",
        -- Reflow (wrap) messages wider than notification window
        reflow = false,
        -- Separator between group name and icon
        icon_separator = " ",
        -- Separator between notification groups
        group_separator = "󰇜󰇜󰇜",
        -- Highlight group used for group separator
        group_separator_hl = "Comment",
        -- How to render notification messages
        render_message = function(msg, cnt)
          return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
        end,
      },
      -- Options related to the notification window and buffer
      window = {
        -- Base highlight group in the notification window
        normal_hl = "Comment",
        -- Background color opacity in the notification window
        winblend = 10,
        -- Border around the notification window
        border = "none",
        -- Stacking priority of the notification window
        zindex = 45,
        -- Maximum width of the notification window
        max_width = 0,
        -- Maximum height of the notification window
        max_height = 0,
        -- Padding from right edge of window boundary
        x_padding = 1,
        -- Padding from bottom edge of window boundary
        y_padding = 0,
        --How to align the notification window
        align = "bottom",
        -- What the notification window position is relative to
        relative = "editor",
        -- Width of each tab character in the notification window
        tabstop = 0,
        -- Filetypes the notification window should avoid
        avoid = {},
      },
    },
    -- Options related to integrating with other plugins
    integration = {},
    -- Options related to logging
    logger = {
      -- Minimum logging level
      level = vim.log.levels.WARN,
      -- Maximum log file size, in KB
      max_size = 10000,
      --  Limit the number of decimals displayed for floats
      float_precision = 0.01,
      -- Where Fidget writes its logs to
      path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
    },
  },
}
