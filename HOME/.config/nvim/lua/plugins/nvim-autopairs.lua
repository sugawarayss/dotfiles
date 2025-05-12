-- 括弧を自動で補完する
return  {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({
      -- Default Config
      disable_filetype                  = {"TelescopePrompt", "spectre_panel", "snacks_picker_input"},
      disable_in_macro                  = true,
      disable_in_visualblock            = false,
      disable_in_replace_mode           = true,
      ignored_next_char                 = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright                  = true,
      enable_afterquote                 = true,
      enable_check_bracket_line         = true,
      enable_moveright_bracket_in_quote = true,
      enable_abbr                       = false,
      break_undo                        = true,
      check_ts                          = false,
      map_cr                            = true,
      map_bs                            = true,
      map_c_h                           = false,
      map_c_w                           = false,
    })
  end
}

