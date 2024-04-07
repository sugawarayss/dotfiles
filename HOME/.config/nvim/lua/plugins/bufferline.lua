-- local color_palette = require("hybrid.colors").setup()

-- タブごとに表示するバッファを切り替える
return {
  'akinsho/bufferline.nvim',
  version = "*",
  lazy = true,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  event = { "BufReadPre" },
  keys = {
    {"L", "<Cmd>BufferLineCycleNext<CR>", mode = "n", { noremap = true, silent = true }, desc = "Switch Current Window to Next BufferLine"},
    {"H", "<Cmd>BufferLineCyclePrev<CR>", mode = "n", { noremap = true, silent = true }, desc = "Switch Current Window to Prev BufferLine" },
    {"<Leader>h", "<Cmd>BufferLineMovePrev<CR>", mode = "n", { noremap = true, silent = true }, desc = "Move BufferLine to Prev"},
    {"<Leader>l", "<Cmd>BufferLineMoveNext<CR>", mode = "n", { noremap = true, silent = true }, desc = "Move BufferLine to Next"},
    {"<C-H>", "<Cmd>BufferLineCloseLeft<CR>", mode = "n", { noremap = true, silent = true }, desc = "Close Left BufferLines"},
    {"<C-L>", "<Cmd>BufferLineCloseRight<CR>", mode = "n", { noremap = true, silent = true }, desc = "Close Right BufferLines"},
    {"<leader>c", ":bd<CR>", mode = "n", { silent = true }, desc = "Close Current Buffer"},
  },
  config = function()
    local color_palette = require("hybrid.colors").setup()
    require("bufferline").setup({
      highlights = {
        fill = {
          fg = color_palette.fg_hard,       -- "#707880"
          bg = color_palette.bg_hard,       -- "#151718"
        },
        -- バッファー区切りの色
        separator = {
          fg = color_palette.bg_hard,       -- "#151718"
          bg = color_palette.bg_hard,       -- "#151718"
        },
        separator_selected = {
          fg = color_palette.bg_hard,       -- "#373b41"
          bg = color_palette.bg_soft,       -- "#151718"
        },
        separator_visible = {
          fg = color_palette.bg_hard,       -- "#151718"
          bg = color_palette.bg_hard,       -- "#151718"
        },
        -- バッファー番号(非選択)の色
        numbers_visible = {
          fg = color_palette.fg_hard,       -- "#373b41"
          bg = color_palette.bg,            -- "#1d1f21"
        },
        -- バッファー名(非選択)の色
        buffer_visible = {
          fg = color_palette.fg_hard,       -- "#707880"
          bg = color_palette.bg,            -- "#1d1f21"
        },

        hint_visible = {
          fg = color_palette.dull_blue,     -- "#7aa6da"
          bg = color_palette.bg,            -- "#151718"
        },
        info_visible= {
          fg = color_palette.dull_magenta,  -- "#b294bb"
          bg = color_palette.bg,            -- "#151718"
        },
        warning_visible= {
          fg = color_palette.dull_yellow,   -- "#f0c674"
          bg = color_palette.bg,            -- "#151718"
        },
        error_visible= {
          fg = color_palette.dull_red,      -- "#cc6666"
          bg = color_palette.bg,            -- "#151718"
        },
        -- 選択中の診断結果に応じて指摘数の色を変更
        info_diagnostic_visible= {
          fg = color_palette.dull_blue,     -- "#7aa6da"
          bg = color_palette.bg,            -- "#151718"
        },
        warning_diagnostic_visible= {
          fg = color_palette.dull_yellow,   -- "#f0c674"
          bg = color_palette.bg,            -- "#151718"
        },
        error_diagnostic_visible= {
          fg = color_palette.dull_red,      -- "#cc6666"
          bg = color_palette.bg,            -- "#151718"
        },
        -- 変更有無インジケータ(非選択)の色
        modified_visible = {
          fg = color_palette.dull_cyan,     -- "#8abeb7"
          bg = color_palette.bg,            -- "#1d1f21"
        },



        -- バッファー番号(選択中)の色
        numbers_selected = {
          fg = color_palette.fg,            -- "#373b41"
          bg = color_palette.bg_soft,       -- "#151718"
        },
        -- バッファー名(選択中)の色
        buffer_selected = {
          fg = color_palette.fg_soft,       -- "#eaeaea"
          bg = color_palette.bg_soft,       -- "#151718"
          bold = true,
          italic = true,
        },
        -- 選択中の診断結果に応じてファイル名の色を変更
        hint_selected = {
          fg = color_palette.bright_green,  -- "#b9ca4a"
          bg = color_palette.bg_soft,       -- "#151718"
        },
        info_selected = {
          fg = color_palette.bright_blue,   -- "#7aa6da"
          bg = color_palette.bg_soft,       -- "#151718"
        },
        warning_selected = {
          fg = color_palette.yellow,        -- "#f0c674"
          bg = color_palette.bg_soft,       -- "#151718"
        },
        error_selected = {
          fg = color_palette.red,           -- "#cc6666"
          bg = color_palette.bg_soft,       -- "#151718"
        },
        -- 選択中の診断結果に応じて指摘数の色を変更
        hint_diagnostic_selected = {
          fg = color_palette.bright_green,  -- "#b9ca4a"
          bg = color_palette.bg_soft,       -- "#151718"
        },
        info_diagnostic_selected = {
          fg = color_palette.bright_blue,   -- "#7aa6da"
          bg = color_palette.bg_soft,       -- "#151718"
        },
        warning_diagnostic_selected = {
          fg = color_palette.yellow,        -- "#f0c674"
          bg = color_palette.bg_soft,       -- "#151718"
        },
        error_diagnostic_selected = {
          fg = color_palette.red,           -- "#cc6666"
          bg = color_palette.bg_soft,       -- "#151718"
        },
        modified_selected = {
          fg = color_palette.cyan,          -- "#8abeb7"
          bg = color_palette.bg_soft,       -- "#151718"
        },
        close_button_selected = {
          fg = color_palette.bright_yellow, -- "#e7c547"
          bg = color_palette.bg_soft,       -- "#151718"
        },
      },
      options = {
        -- mode = "buffers", -- tabs | buffers
        --style_preset = bufferline.style_preset.default,
        themable = true,
        numbers = function(opts)
          return string.format("%s.%s", opts.ordinal, opts.lower())
        end,
        --close_command = "bdelete! %d",
        --right_mouse_command = "bdelete! %d",
        --left_mouse_command = "buffer %d",
        --middle_mouse_command = nil,
        indicator = {
          icon = "|  ",
          style = "icon",
        },
        -- buffer_close_icon = '󰅖',
        -- modified_icon = '●',
        -- close_icon = '',
        -- left_trunc_marker = '',
        -- right_trunc_marker = '',

        -- name_formatter = function(buf)
        --   return buf.path .. buf.name
        -- end,
        max_name_length = 100,
        max_prefix_length = 15,
        truncate_names = true,
        tab_size = 30,
        diagnostics = "nvim_lsp",
        -- diagnostics_update_in_insert = false
        diagnostics_indicator = function(count, _, _, _)
          return "(" .. count .. ")"
        end,
        -- NOTE: this will be called a lot so don't do any heavy processing here
        custom_filter = function(buf_number)
          -- filter out filetypes you don't want to see
          if vim.bo[buf_number].filetype == "qf" then
            return false
          end
          if vim.bo[buf_number].buftype == "terminal" then
            return false
          end
          -- -- filter out by buffer name
          if vim.api.nvim_buf_get_name(buf_number) == "" or vim.api.nvim_buf_get_name(buf_number) == "[No Name]" then
            return false
          end
          if vim.api.nvim_buf_get_name(buf_number) == "[dap-repl]" then
            return false
          end
          -- -- filter out based on arbitrary rules
          -- -- e.g. filter out vim wiki buffer from tabline in your work repo
          -- if vim.uv.cwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
          --   return true
          -- end
          return true
        end,
        offsets = {
          {
             filetype = "neo-tree",
             text = "File Explorer",
             text_align = "left",
             separator = true,
          },
        },
        color_icons = true,
        get_element_icon = function(element)
          local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
          return icon, hl
        end,
        -- show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        -- show_duplicate_prefix = ture,
        -- persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        -- move_wraps_at_ends = false,
        separator_style = "slant", -- slant | padded_slant | slope | padded_slope | thick | thin
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = {'close'}
        },
        sort_by = function(buffer_a, buffer_b)
          if not buffer_a and buffer_b then
            return true
          elseif buffer_a and not buffer_b then
            return false
          end
          return buffer_a.ordinal < buffer_b.ordinal
        end,
      },
    })
  end
}
