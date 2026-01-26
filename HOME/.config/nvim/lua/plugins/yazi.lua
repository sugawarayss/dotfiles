-- yazi (file explorer) plugin
return {
  "mikavilpas/yazi.nvim",
  version = "*",
  cond = function()
    return not vim.g.vscode
  end,
  cmd = { "Yazi" },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    local wk = require("which-key")
    wk.add({
      {
        "<C-t><C-t>",
        "<cmd>Yazi<cr>",
        mode = { "n", "v" },
        icon = "📂",
        desc = "Yazi - 現在のファイルをyaziで開く",
      },
    })
  end,
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    open_multiple_tabs = false,
    -- ファイルを選択せずにyaziを閉じた時、Neovimのワーキングディレクトリ
    change_neovim_cwd_on_close = false,
    highlight_groups = {
      hovered_buffer = nil,
      hovered_buffer_in_same_directory = nil,
    },
    floating_window_scaling_factor = 0.9,
    yazi_floating_window_winblend = 0,
    yazi_floating_window_border = "rounded",
    yazi_floating_window_zindex = nil,
    keymaps = {
      show_help = "<f1>",
      open_file_in_vertical_split = "<c-v>",
      open_file_in_horizontal_split = "<c-x>",
      open_file_in_tab = "<c-t>",
      grep_in_directory = "<c-s>",
      replace_in_directory = "<c-g>",
      cycle_open_buffers = "<tab>",
      copy_relative_path_to_selected_files = "<c-y>",
      send_to_quickfix_list = "<c-q>",
      change_working_directory = "<c-\\>",
      open_and_pick_window = "<c-o>",
    },
    clipboard_register = "*",
    highlight_hovered_buffers_in_same_directory = true,
    future_features = {
      -- use a file to store the last directory that yazi was in before it was
      use_cwd_file = true,
      new_shell_escaping = true,
    },
  },
}
