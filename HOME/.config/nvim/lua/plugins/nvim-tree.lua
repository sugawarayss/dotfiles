-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function edit_or_open()
    local node = api.tree.get_node_under_cursor()
    if node.nodes ~= nil then
      api.node.open.edit()
    else
      api.node.open.edit()
      api.tree.close()
    end
  end

  local function opt(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "l", edit_or_open, opt("edit or open"))
  vim.keymap.set("n", "h", api.tree.collapse_all, opt("close"))
  vim.keymap.set("n", "<C-v>", api.node.open.vertical, opt("open vertical"))
  vim.keymap.set("n", "<C-s>", api.node.open.horizontal, opt("open split"))
  vim.keymap.set("n", "<C-p>", api.node.open.preview, opt("open preview"))
end

return {
    "kyazdani42/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- 遅延読み込みする
    lazy = true,
    -- 指定キーが押された時にロードする
    keys = {
        { "<C-n>", ":NvimTreeToggle<CR>", mode = "n", desc = "Toggle File Exploer" },
    },
    config = function()
      require("nvim-tree").setup({
        on_attach = my_on_attach,
        filters = {
          git_ignored = false,
          dotfiles = false,
          custom = {".DS_Store",},
        },
        renderer = {
          highlight_git = true,
          highlight_opened_files = "all",
          highlight_modified = "icon",
          indent_markers = { enable = true },
          special_files = {
            "Cargo.toml",
            "Makefile",
            "README.md",
            "readme.md",
            "pyproject.toml",
            "Pipfile",
          },
          icons = {
            web_devicons = {
              folder = { enable = true, color = true },
            },
            show = {
              git = true,
            },
            glyphs = {
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
        view = {
          -- windowで表示
          number = true,
          width = 50,
          -- floating windowで表示
          -- float = {
          --   enable = true,
          --   open_win_config = {
          --     width = 50,
          --     height = 70,
          --   },
          -- }
        },
        actions = {
          file_popup = {
            open_win_config = {
              border = "single",
            },
          },
        },
      })
    end
}
