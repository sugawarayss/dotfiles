local utils = {}

utils.keymap = function(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

utils.exec = function(command)
  vim.api.nvim_exec(command, false)
end

utils.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

utils.at = function(str, index)
  return string.sub(str, index, index)
end

-- Helper function to check if value passed by parameter is a table
-- @obj {table}
-- @returns {boolean}
utils.is_table = function(obj)
  return type(obj) == "table"
end

-- Verify if table object works as an array
-- @param obj {table}
-- @return {boolean}
utils.is_array = function(obj)
  if not utils.is_table(obj) then
    return false
  end

  local i = 0
  for _ in pairs(obj) do
    i = i + 1
    if obj[i] == nil then
      return false
    end
  end

  return true
end

-- Checks wether value is nil
-- @obj {any}
-- @returns {boolean}
utils.is_nil = function(value)
  return value == nil
end

-- Checks if parameter is an empty table
-- @param obj {table}
-- @return {boolean}
utils.is_empty = function(obj)
  return utils.is_array(obj) and #obj == 0
end

-- Returns a shallow copy of a portion of a table into a new table
-- @param obj {table}
-- @param start {number} start value
-- @param finish {number} end value
-- @return {boolean}
utils.slice_table = function(obj, start, finish)
  if utils.is_empty(obj) or start == finish then
    return {}
  end

  local output = {}
  local _finish = #obj
  local _start = 1

  if start >= 0 then
    _start = start
  elseif utils.is_nil(finish) and start < 0 then
    _start = #obj + start + 1
  end

  if finish and finish >= 0 then
    _finish = finish - 1
  elseif finish and finish < 0 then
    _finish = #obj + finish
  end

  for i = _start, _finish do
    table.insert(output, obj[i])
  end

  return output
end

-- 親ディレクトリを辿ってプロジェクトルートを探す
local function search_up(dir, root_markers)
  for _, marker in ipairs(root_markers) do
    if vim.fn.filereadable(dir .. "/" .. marker) == 1 or vim.fn.isdirectory(dir .. "/" .. marker) == 1 then
      return dir
    end
  end
  local parent = vim.fn.fnamemodify(dir, ":h")
  if parent == dir then
    return nil -- ルートディレクトリに到達
  end
  -- 再帰的に親ディレクトリを探索
  return search_up(parent, root_markers)
end

-- 配下のディレクトリでdir
local function search_down(dir, root_markers)
  --vim.notify("dir: " .. dir, vim.log.levels.INFO)
  --vim.notify("root_markers: ".. vim.inspect(root_markers), vim.log.levels.INFO)
  -- 現在のディレクトリにmarkersがあるかチェック
  for _, marker in ipairs(root_markers) do
    if vim.fn.filereadable(dir .. "/" .. marker) == 1 or vim.fn.isdirectory(dir .. "/" .. marker) == 1 then
      return dir
    end
  end

  -- 配下のディレクトリを探索（1階層のみ）
  local subdirs = vim.fn.globpath(dir, "*", 0, 1)
  for _, subdir in ipairs(subdirs) do
    if vim.fn.isdirectory(subdir) == 1 then
      for _, marker in ipairs(root_markers) do
        if vim.fn.filereadable(subdir .. "/" .. marker) == 1 or vim.fn.isdirectory(subdir .. "/" .. marker) == 1 then
          return subdir
        end
      end
    end
  end
  return nil
end

-- プロジェクトルートを探す関数
utils.find_project_root = function(root_markers)
  local current_dir = vim.fn.expand("%:p:h") -- 現在のファイルのディレクトリ
  --vim.notify("root_markers: ".. vim.inspect(root_markers), vim.log.levels.INFO)

  -- まず上向きに探索
  local root_from_up = search_up(current_dir, root_markers)
  if root_from_up then
    return root_from_up
  end

  -- 見つからなかった場合は下向きに探索（モノレポ対応）
  local root_from_down = search_down(current_dir, root_markers)
  if root_from_down then
    return root_from_down
  end

  return vim.fn.getcwd()
end

-- Python の venv を自動検出するための関数
utils.find_python_venv = function(root_markers)
  local root_dir = require("utils").find_project_root(root_markers)
  vim.notify("Project root: " .. root_dir, vim.log.levels.INFO)

  -- 仮想環境のパスパターン
  local venv_paths = {
    root_dir .. "/.venv/bin/python", -- Linux/Mac
    --root_dir .. "/.venv/Scripts/python.exe", -- Windows
  }

  for _, path in ipairs(venv_paths) do
    -- local exists = vim.fn.filereadable(path) == 1
    local executable = vim.fn.executable(path) == 1

    if executable then
      vim.notify("Found Python venv: " .. path)
      return path
    end
  end
  -- 見つからない場合はシステムのpython
  local system_python = vim.fn.exepath("python3") or vim.fn.exepath("python")
  vim.notify("venv not found.Using system Python: " .. system_python, vim.log.levels.WARNING)
  return system_python
end

return utils
