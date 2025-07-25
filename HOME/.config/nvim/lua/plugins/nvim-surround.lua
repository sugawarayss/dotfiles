-- 囲う系の操作を簡単にするプラグイン
return {
  "kylechui/nvim-surround",
  lazy = true,
  enabled = true,
  version = "^3.0.0",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "S",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
      surrounds = {
        ["("] = {
          add = { "( ", " )" },
          find = function()
            return M.get_selection({ motion = "a(" })
          end,
          delete = "^(. ?)().-( ?.)()$",
        },
        [")"] = {
          add = { "(", ")" },
          find = function()
            return M.get_selection({ motion = "a)" })
          end,
          delete = "^(.)().-(.)()$",
        },
        ["{"] = {
          add = { "{ ", " }" },
          find = function()
            return M.get_selection({ motion = "a{" })
          end,
          delete = "^(. ?)().-( ?.)()$",
        },
        ["}"] = {
          add = { "{", "}" },
          find = function()
            return M.get_selection({ motion = "a}" })
          end,
          delete = "^(.)().-(.)()$",
        },
        ["<"] = {
          add = { "< ", " >" },
          find = function()
            return M.get_selection({ motion = "a<" })
          end,
          delete = "^(. ?)().-( ?.)()$",
        },
        [">"] = {
          add = { "<", ">" },
          find = function()
            return M.get_selection({ motion = "a>" })
          end,
          delete = "^(.)().-(.)()$",
        },
        ["["] = {
          add = { "[ ", " ]" },
          find = function()
            return M.get_selection({ motion = "a[" })
          end,
          delete = "^(. ?)().-( ?.)()$",
        },
        ["]"] = {
          add = { "[", "]" },
          find = function()
            return M.get_selection({ motion = "a]" })
          end,
          delete = "^(.)().-(.)()$",
        },
        ["'"] = {
          add = { "'", "'" },
          find = function()
            return M.get_selection({ motion = "a'" })
          end,
          delete = "^(.)().-(.)()$",
        },
        ['"'] = {
          add = { '"', '"' },
          find = function()
            return M.get_selection({ motion = 'a"' })
          end,
          delete = "^(.)().-(.)()$",
        },
        ["`"] = {
          add = { "`", "`" },
          find = function()
            return M.get_selection({ motion = "a`" })
          end,
          delete = "^(.)().-(.)()$",
        },
        ["i"] = { -- TODO: Add find/delete/change functions
          add = function()
            local left_delimiter = M.get_input("Enter the left delimiter: ")
            local right_delimiter = left_delimiter and M.get_input("Enter the right delimiter: ")
            if right_delimiter then
              return { { left_delimiter }, { right_delimiter } }
            end
          end,
          find = function() end,
          delete = function() end,
        },
        ["t"] = {
          add = function()
            local user_input = M.get_input("Enter the HTML tag: ")
            if user_input then
              local element = user_input:match("^<?([^%s>]*)")
              local attributes = user_input:match("^<?[^%s>]*%s+(.-)>?$")

              local open = attributes and element .. " " .. attributes or element
              local close = element

              return { { "<" .. open .. ">" }, { "</" .. close .. ">" } }
            end
          end,
          find = function()
            return M.get_selection({ motion = "at" })
          end,
          delete = "^(%b<>)().-(%b<>)()$",
          change = {
            target = "^<([^%s<>]*)().-([^/]*)()>$",
            replacement = function()
              local user_input = M.get_input("Enter the HTML tag: ")
              if user_input then
                local element = user_input:match("^<?([^%s>]*)")
                local attributes = user_input:match("^<?[^%s>]*%s+(.-)>?$")

                local open = attributes and element .. " " .. attributes or element
                local close = element

                return { { open }, { close } }
              end
            end,
          },
        },
        ["T"] = {
          add = function()
            local user_input = M.get_input("Enter the HTML tag: ")
            if user_input then
              local element = user_input:match("^<?([^%s>]*)")
              local attributes = user_input:match("^<?[^%s>]*%s+(.-)>?$")

              local open = attributes and element .. " " .. attributes or element
              local close = element

              return { { "<" .. open .. ">" }, { "</" .. close .. ">" } }
            end
          end,
          find = function()
            return M.get_selection({ motion = "at" })
          end,
          delete = "^(%b<>)().-(%b<>)()$",
          change = {
            target = "^<([^>]*)().-([^/]*)()>$",
            replacement = function()
              local user_input = M.get_input("Enter the HTML tag: ")
              if user_input then
                local element = user_input:match("^<?([^%s>]*)")
                local attributes = user_input:match("^<?[^%s>]*%s+(.-)>?$")

                local open = attributes and element .. " " .. attributes or element
                local close = element

                return { { open }, { close } }
              end
            end,
          },
        },
        ["f"] = {
          add = function()
            local result = M.get_input("Enter the function name: ")
            if result then
              return { { result .. "(" }, { ")" } }
            end
          end,
          find = function()
            if vim.g.loaded_nvim_treesitter then
              local selection = M.get_selection({
                query = {
                  capture = "@call.outer",
                  type = "textobjects",
                },
              })
              if selection then
                return selection
              end
            end
            return M.get_selection({ pattern = "[^=%s%(%){}]+%b()" })
          end,
          delete = "^(.-%()().-(%))()$",
          change = {
            target = "^.-([%w_]+)()%(.-%)()()$",
            replacement = function()
              local result = M.get_input("Enter the function name: ")
              if result then
                return { { result }, { "" } }
              end
            end,
          },
        },
        invalid_key_behavior = {
          -- By default, we ignore control characters for adding/finding because they are more likely typos than
          -- intentional. We choose NOT to for deletion, as users could have redefined the find key to something like
          -- ‘.-’. In this case we should still trim a character from each side, instead of early returning nil.
          add = function(char)
            if not char or char:find("%c") then
              return nil
            end
            return { { char }, { char } }
          end,
          find = function(char)
            if not char or char:find("%c") then
              return nil
            end
            return M.get_selection({
              pattern = vim.pesc(char) .. ".-" .. vim.pesc(char),
            })
          end,
          delete = function(char)
            if not char then
              return nil
            end
            return M.get_selections({
              char = char,
              pattern = "^(.)().-(.)()$",
            })
          end,
        },
      },
      -- aliases = {
      --   ["a"] = ">",
      --   ["b"] = ")",
      --   ["B"] = "}",
      --   ["r"] = "]",
      --   ["q"] = { '"', "'", "`" },
      --   ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
      -- },
      highlight = { duration = 0 },
      move_cursor = "begin",
      indent_lines = function(start, stop)
        local b = vim.bo
        -- Only re-indent the selection if a formatter is set up already
        if start < stop and (b.equalprg ~= "" or b.indentexpr ~= "" or b.cindent or b.smartindent or b.lisp) then
          vim.cmd(string.format("silent normal! %dG=%dG", start, stop))
          require("nvim-surround.cache").set_callback("")
        end
      end,
    })
  end,
}
