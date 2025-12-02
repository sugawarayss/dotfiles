return {
  "WilliamHsieh/overlook.nvim",
  -- cond = function()
  --   return vim.g.vscode
  -- end,
  init = function()
    local wk = require("which-key")
    wk.add({
      {
        "gd",
        function()
          require("overlook.api").peek_definition()
        end,
        mode = { "n" },
        desc = "カーソル位置の定義箇所を垣間見る",
      },
      {
        "<leader>pp",
        function()
          require("overlook.api").peek_cursor()
        end,
        mode = { "n" },
        desc = "カーソル位置のポップアップを開く",
      },
      {
        "<leader>pu",
        function()
          require("overlook.api").restore_popup()
        end,
        mode = { "n" },
        desc = "直前のポップアップを再度開く",
      },
      {
        "<leader>pU",
        function()
          require("overlook.api").restore_all_popup()
        end,
        mode = { "n" },
        desc = "直前のポップアップを全て開く",
      },
      {
        "<leader>pc",
        function()
          require("overlook.api").close_all()
        end,
        mode = { "n" },
        desc = "全てのポップアップを閉じる",
      },
      {
        "<leader>pf",
        function()
          require("overlook.api").switch_focus()
        end,
        mode = { "n" },
        desc = "ポップアップと元のウィンドウでフォーカスを切替える",
      },
      -- {
      --   "<leader>ps",
      --   function()
      --     require("overlook.api").open_in_split()
      --   end,
      --   mode = { "n" },
      --   desc = "ポップアップの箇所を水平分割で開く",
      -- },
      -- {
      --   "<leader>pv",
      --   function()
      --     require("overlook.api").open_in_vsplit()
      --   end,
      --   mode = { "n" },
      --   desc = "ポップアップの箇所を垂直分割で開く",
      -- },
      {
        "<leader>pt",
        function()
          require("overlook.api").open_in_tab()
        end,
        mode = { "n" },
        desc = "ポップアップの箇所を新規タブで開く",
      },
      -- {
      --   "<leader>po",
      --   function()
      --     require("overlook.api").open_in_original_window()
      --   end,
      --   mode = { "n" },
      --   desc = "現在ウィンドウをポップアップ内容で入替える",
      -- },
    })
    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = vim.api.nvim_create_augroup("overlook_enter_mapping", { clear = true }),
      pattern = "*",
      callback = function()
        vim.schedule(function()
          if vim.w.is_overlook_popup then
            -- open in original window on enter
            vim.keymap.set("n", "<CR>", function()
              require("overlook.api").open_in_original_window()
            end, { buffer = true, desc = "Overlook: Open in original window" })

            -- open in vsplit on ctrl+enter
            for _, lhs in ipairs({ "<C-CR>" }) do
              vim.keymap.set("n", lhs, function()
                require("overlook.api").open_in_vsplit()
              end, { buffer = true, desc = "Overlook: Open in vertical split" })
            end
            -- open in split on shift+enter
            for _, lhs in ipairs({ "<S-CR>" }) do
              vim.keymap.set("n", lhs, function()
                require("overlook.api").open_in_split()
              end, { buffer = true, desc = "Overlook: Open in split" })
            end
          end
        end)
      end,
    })
  end,
  opts = {
    ui = {
      border = "rounded", -- Border style: "none", "single", "double", "rounded", etc.
      z_index_base = 30, -- Base z-index for first popup
      row_offset = 2, -- Initial row offset from cursor
      col_offset = 50, -- Initial column offset from cursor
      stack_row_offset = 1, -- Vertical offset for stacked popups
      stack_col_offset = 2, -- Horizontal offset for stacked popups
      width_decrement = 2, -- Width reduction for each stacked popup
      height_decrement = 1, -- Height reduction for each stacked popup
      min_width = 10, -- Minimum popup width
      min_height = 3, -- Minimum popup height
      size_ratio = 0.65, -- Default size ratio (0.0 to 1.0)
      keys = {
        close = "q", -- Key to close the topmost popup
      },
    },
    -- Optional callback when all popups are closed
    on_stack_empty = function()
      -- Your custom logic here
      vim.notify("All Overlook popups are closed.")
      vim.cmd("redraw")
    end,
  },
}
