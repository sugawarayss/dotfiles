if not vim.g.vscode then
  return {
    -- タブごとに表示するバッファを切り替える
    {
      "akinsho/bufferline.nvim",
      version = "*",
      lazy = true,
      event = { "BufReadPre" },
      keys = {
        {"L",         "<Cmd>BufferLineCycleNext<CR>",  mode = "n", { noremap = true, silent = true }, desc = "次のバッファを表示"},
        {"H",         "<Cmd>BufferLineCyclePrev<CR>",  mode = "n", { noremap = true, silent = true }, desc = "前のバッファを表示" },
        {"<Leader>h", "<Cmd>BufferLineMovePrev<CR>",   mode = "n", { noremap = true, silent = true }, desc = "バッファを左に移動"},
        {"<Leader>l", "<Cmd>BufferLineMoveNext<CR>",   mode = "n", { noremap = true, silent = true }, desc = "バッファを右に移動"},
        {"<C-H>",     "<Cmd>BufferLineCloseLeft<CR>",  mode = "n", { noremap = true, silent = true }, desc = "左のバッファを閉じる"},
        {"<C-L>",     "<Cmd>BufferLineCloseRight<CR>", mode = "n", { noremap = true, silent = true }, desc = "右のバッファを閉じる"},
        {"<M-c>",     "<Cmd>BufferLinePickClose<CR>",  mode = "n", { noremap = true, silent = true }, desc = "選択したバッファを閉じる"},
        -- disable keybind because CopilotChat use this keybind
        -- {"<leader>c", ":bd<CR>", mode = "n", { silent = true }, desc = "Close Current Buffer"},
      },
      config = function()
        local color_palette = require("tokyonight.colors").setup()
        require("bufferline").setup({
          highlights = {
            error_selected              = { fg = color_palette.red },    -- #f7768e
            warning_diagnostic_selected = { fg = color_palette.orange }, -- #ff9e64
            error_diagnostic_selected   = { fg = color_palette.red },    -- #f7768e
            close_button_selected       = { fg = color_palette.yellow }  -- #e0af68
          },
          options = {
            themable = true,
            numbers = function(opts)
              return string.format("%s.%s", opts.ordinal, opts.lower())
            end,
            indicator = {
              icon = "|  ",
              style = "icon",
            },
            max_name_length = 100,
            max_prefix_length = 15,
            truncate_names = true,
            tab_size = 30,
            diagnostics = "nvim_lsp",
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
            -- show_duplicate_prefix = true,
            -- persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
            -- move_wraps_at_ends = false,
            separator_style = "slant", -- slant | padded_slant | slope | padded_slope | thick | thin
            enforce_regular_tabs = true,
            always_show_bufferline = true,
            hover = {
              enabled = true,
              delay = 200,
              reveal = {"close"}
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
    },
    -- bufferline.nvim の依存プラグイン
    { "nvim-tree/nvim-web-devicons", lazy = true },
  }
else
  return {}
end
