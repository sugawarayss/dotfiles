return {
  "fei6409/log-highlight.nvim",
  ft = { "log" },
  config = function()
    require("log-highlight").setup({
      extension = "log",
      filename = {
        "syslog",
      },
      pattern = {
        "%/var%/log%/.*",
        "console%-ramoops.*",
        "log.*%.txt",
        "logcat.*",
      },
      keryword = {
        error = "ERROR_MSG",
        warning = { "WARN_X", "WARN_Y" },
        info = { "INFORMATION" },
        debug = {},
        pass = {},
      },
    })
  end,
}
