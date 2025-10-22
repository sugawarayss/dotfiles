-- RipGrepを使って置換できるプラグイン
return {
  "chrisgrieser/nvim-rip-substitute",
  cmd = "RipSubstitute",
  init = function()
    local wk = require("which-key")
    wk.add({
      {
        "<leader>fs",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" },
        desc = "RipGrepで置換",
      },
    })
  end,
  opts = function()
    require("rip-substitute").setup({
      popupWin = {
        title = " Substitute by Ripgrep",
        border = getBorder(), -- `vim.o.winborder` on nvim 0.11, otherwise "rounded"
        matchCountHlGroup = "Keyword",
        noMatchHlGroup = "ErrorMsg",
        position = "bottom", ---@type "top"|"bottom"
        hideSearchReplaceLabels = false,
        hideKeymapHints = false,
        disableCompletions = true, -- disables all blink.cmp completions
      },
      prefill = {
        normal = "cursorWord", ---@type "cursorWord"|false
        visual = "selection", ---@type "selection"|false (does not work with ex-command – see README)
        startInReplaceLineIfPrefill = false,
        alsoPrefillReplaceLine = false,
      },
      keymaps = { -- normal mode (if not stated otherwise)
        abort = "q",
        confirm = "<CR>",
        insertModeConfirm = "<C-CR>",
        prevSubstitutionInHistory = "<Up>",
        nextSubstitutionInHistory = "<Down>",
        toggleFixedStrings = "<C-f>", -- ripgrep's `--fixed-strings`
        toggleIgnoreCase = "<C-c>", -- ripgrep's `--ignore-case`
        openAtRegex101 = "R",
        showHelp = "?",
      },
      incrementalPreview = {
        matchHlGroup = "IncSearch",
        rangeBackdrop = {
          enabled = true,
          blend = 50, -- between 0 and 100
        },
      },
      regexOptions = {
        startWithFixedStringsOn = false,
        startWithIgnoreCase = false,
        pcre2 = true, -- enables lookarounds and backreferences, but slightly slower
        autoBraceSimpleCaptureGroups = true, -- disable if using named capture groups (see README for details)
      },
      editingBehavior = {
        -- Typing `()` in the `search` line, automatically adds `$n` to the `replace` line.
        autoCaptureGroups = false,
      },
      notification = {
        onSuccess = true,
        icon = "",
      },
      debug = false, -- extra notifications for debugging
    })
  end,
}
