vim.cmd.highlight("TabLineSel guibg=#ddc7a1")

local bufferline = require("bufferline")
local mocha = require("catppuccin.palettes").get_palette "mocha"

bufferline.setup({
  highlights = require("catppuccin.groups.integrations.bufferline").get {
    styles = { "italic", "bold" },
    custom = {
      all = {
        fill = { bg = "#000000" },
      },
      mocha = {
        background = { fg = mocha.text },
      },
    },
  },
  options = {
    -- mode = "buffers", -- tabs | buffers
    --style_preset = bufferline.style_preset.default,
    --themable = true,
    numbers = function(opts)
      return string.format("%s.%s", opts.ordinal, opts.lower())
    end,
    --close_command = "bdelete! %d",
    --right_mouse_command = "bdelete! %d",
    --left_mouse_command = "buffer %d",
    --middle_mouse_command = nil,
    indicator = {
      style = "underline",
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
    tab_size = 20,
    diagnostics = "nvim_lsp",
    -- diagnostics_update_in_insert = false
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
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
    -- offsets = {
    --   {
    --      filetype = "NvimTree",
    --      text = "File Explorer",
    --      text_align = "left" | "center" | "right"
    --   }
    -- },
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
},
vim.keymap.set("n", "L", "<Cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true }),
vim.keymap.set("n", "H", "<Cmd>BufferLineCyclePrev<CR>", { noremap = true, silent = true }),
vim.keymap.set("n", "<Leader>h", "<Cmd>BufferLineMovePrev<CR>", { noremap = true, silent = true }),
vim.keymap.set("n", "<Leader>l", "<Cmd>BufferLineMoveNext<CR>", { noremap = true, silent = true }),
vim.keymap.set("n", "<C-S-h>", "<Cmd>BufferLineCloseLeft<CR>", { noremap = true, silent = true }),
vim.keymap.set("n", "<C-S-l>", "<Cmd>BufferLineCloseRight<CR>", { noremap = true, silent = true })
)
