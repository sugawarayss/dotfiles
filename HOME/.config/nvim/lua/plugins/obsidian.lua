-- vim から Obsidian を操作するプラグイン
vim.opt.conceallevel = 1
vim.cmd([[cab tag ObsidianTags]])
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  cmd = {
    "ObsidianOpen", -- Obsidianアプリでノートを開く
    "ObsidianNew", -- 新しいノートを作成する
    "ObsidianQuickSwitch", -- pickerでノートの名前で検索してバッファとして開く
    "ObsidianFollowLink", -- カーソル位置のノートへのリンクを画面分割で開く
    "ObsidianBacklink", -- 現在のバッファへの参照をpicker で開く
    "ObsidianTags", -- 入力したタグ名を含むノートをpickerで開く
    "ObsidianToday", -- 今日分のデイリーノートを開く
    "ObsidianTomorrow", -- 次の平日のデイリーノートを開く(週末を考慮する)
    "ObsidianDailies", -- デイリーノート一覧をpickerで開く
    "ObsidianTemplate", -- テンプレートを選択してノートを作成する
    "ObsidianSearch", -- pickerを使ってノートを検索 (または作成) する
    "ObsidianLink", -- 選択したテキストをノートへのリンクに変換する
    "ObsidianLinkNew", -- 新しいノートを作成して、選択したテキストがあれば、そのノートへのリンクに変換する
    "ObsidianLinks", -- 現在のバッファにあるノートへのリンクをpickerで開く
    "ObsidianExtractNote", -- 選択したテキストをノートに抽出して、それにリンクする
    "ObsidianWorkspace", -- 別のワークスペースに切り替える
    "ObsidianPasteImg", -- クリップボードから画像を保存して、Markdown画像リンクとして追加する
    "ObsidianRename", -- カーソル位置のノート名を変更する(全体のリンクも変更される)
    "ObsidianToggleCheckbox", -- チェックボックスをトグルする
    "ObsidianNewFromTemplate", -- テンプレートフォルダ内のテンプレートから新しいノートを作成する
    "ObsidianTOC", -- 現在のノートの目次をpicker list に読み込む
  },
  keys = {
    { "<Leader>sn", "<Cmd>ObsidianQuickSwitch<CR>", mode = "n", { noremap = true, silent = true }, desc = "Obsidianノートを検索" },
    { "<Leader>on", "<Cmd>ObsidianNewFromTemplate<CR>", mode = "n", { noremap = true, silent = true }, desc = "Obsidianノートを開く(作成)" },
    {
      "<Leader>od",
      "<Cmd>ObsidianToday<CR>",
      mode = "n",
      { noremap = true, silent = true },
      desc = "デイリーノートを開く(作成)",
    },
    {
      "<Leader>oc",
      "<Cmd>ObsidianTOC<CR>",
      mode = "n",
      { noremap = true, silent = true },
      desc = "現在のノートの目次を表示",
    },
    {
      "<Leader>otc",
      "<Cmd>ObsidianToggleCheckbox<CR>",
      mode = "n",
      { noremap = true, silent = true },
      desc = "チェックボックスをトグル",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    open_notes_in = "vsplit",
    workspaces = {
      {
        name = "work",
        path = "~/PROJECTS/sugawarayss/obsidian_notes",
      },
    },
    note_frontmatter_func = function(note)
      -- This is equivalent to the default frontmatter function.
      local out = { tags = note.tags }
      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,
    daily_notes = {
      folder = "daily",
      template = "daily.md",
    },
    completion = {
      -- Set to false to disable completion
      nvim_cmp = true,
      -- Trigger completion at 2 characters
      min_chars = 2,
    },
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
  },
}
