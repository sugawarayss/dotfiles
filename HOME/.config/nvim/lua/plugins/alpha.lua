local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local coolLines   = {
  [[    ███╗   ███╗ █████╗ ██╗  ██╗███████╗   ]],
  [[    ████╗ ████║██╔══██╗██║ ██╔╝██╔════╝   ]],
  [[    ██╔████╔██║███████║█████╔╝ █████╗     ]],
  [[    ██║╚██╔╝██║██╔══██║██╔═██╗ ██╔══╝     ]],
  [[    ██║ ╚═╝ ██║██║  ██║██║  ██╗███████╗   ]],
  [[    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ]],
  [[      ██████╗ ██████╗  ██████╗ ██╗        ]],
  [[     ██╔════╝██╔═══██╗██╔═══██╗██║        ]],
  [[     ██║     ██║   ██║██║   ██║██║        ]],
  [[     ██║     ██║   ██║██║   ██║██║        ]],
  [[     ╚██████╗╚██████╔╝╚██████╔╝███████╗   ]],
  [[      ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝   ]],
  [[███████╗████████╗██╗   ██╗███████╗███████╗]],
  [[██╔════╝╚══██╔══╝██║   ██║██╔════╝██╔════╝]],
  [[███████╗   ██║   ██║   ██║█████╗  █████╗  ]],
  [[╚════██║   ██║   ██║   ██║██╔══╝  ██╔══╝  ]],
  [[███████║   ██║   ╚██████╔╝██║     ██║     ]],
  [[╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝     ]],
}
local robustLines = {
  [[        ██████╗ ██╗   ██╗██╗██╗     ██████╗         ]],
  [[        ██╔══██╗██║   ██║██║██║     ██╔══██╗        ]],
  [[        ██████╔╝██║   ██║██║██║     ██║  ██║        ]],
  [[        ██╔══██╗██║   ██║██║██║     ██║  ██║        ]],
  [[        ██████╔╝╚██████╔╝██║███████╗██████╔╝        ]],
  [[        ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝         ]],
  [[ ██████╗  ██████╗ ██████╗ ██╗   ██╗███████╗████████╗]],
  [[ ██╔══██╗██╔═══██╗██╔══██╗██║   ██║██╔════╝╚══██╔══╝]],
  [[ ██████╔╝██║   ██║██████╔╝██║   ██║███████╗   ██║   ]],
  [[ ██╔══██╗██║   ██║██╔══██╗██║   ██║╚════██║   ██║   ]],
  [[ ██║  ██║╚██████╔╝██████╔╝╚██████╔╝███████║   ██║   ]],
  [[ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝   ╚═╝   ]],
  [[     ███████╗████████╗██╗   ██╗███████╗███████╗     ]],
  [[     ██╔════╝╚══██╔══╝██║   ██║██╔════╝██╔════╝     ]],
  [[     ███████╗   ██║   ██║   ██║█████╗  █████╗       ]],
  [[     ╚════██║   ██║   ██║   ██║██╔══╝  ██╔══╝       ]],
  [[     ███████║   ██║   ╚██████╔╝██║     ██║          ]],
  [[     ╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝          ]],
}


local efficientLines = {
  [[             ██████╗██████╗  █████╗ ███████╗████████╗            ]],
  [[            ██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝            ]],
  [[            ██║     ██████╔╝███████║█████╗     ██║               ]],
  [[            ██║     ██╔══██╗██╔══██║██╔══╝     ██║               ]],
  [[            ╚██████╗██║  ██║██║  ██║██║        ██║               ]],
  [[             ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝               ]],
  [[███████╗███████╗███████╗██╗ ██████╗██╗███████╗███╗   ██╗████████╗]],
  [[██╔════╝██╔════╝██╔════╝██║██╔════╝██║██╔════╝████╗  ██║╚══██╔══╝]],
  [[█████╗  █████╗  █████╗  ██║██║     ██║█████╗  ██╔██╗ ██║   ██║   ]],
  [[██╔══╝  ██╔══╝  ██╔══╝  ██║██║     ██║██╔══╝  ██║╚██╗██║   ██║   ]],
  [[███████╗██║     ██║     ██║╚██████╗██║███████╗██║ ╚████║   ██║   ]],
  [[╚══════╝╚═╝     ╚═╝     ╚═╝ ╚═════╝╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ]],
  [[  ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗███████╗  ]],
  [[  ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║██╔════╝  ]],
  [[  ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║███████╗  ]],
  [[  ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║╚════██║  ]],
  [[  ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║███████║  ]],
  [[  ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝╚══════╝  ]],
}

local tool_2001_2006 = {
  [[           __/*                                                                                 '_1*G ]],
  [[     .!|}%pO888.                                                                           .|/wq$8888 ]],
  [[     >888888888.                                                                           e888888888 ]],
  [[ """"}888888888!""""`                                                                      e888888888 ]],
  [[ 888888888888888888p"                                                                      e888888888 ]],
  [[ ||||I$88888888>|||r'               .?4kkkL;                         :/Pkkk|,              e888888888 ]],
  [[     "p88888888.                 _<%888888882"                    `TP88888888C_            e888888888 ]],
  [[     "p88888888.               !k8888888888888y.               .=98888888888888u           e888888888 ]],
  [[     "p88888888699999999999999p8888888888888888ppppppppppppppppd8888888888888888p9999999999$888888888 ]],
  [[     "p888888888888888888888881-,388888888888888888888888888888+,-t8888888888888888888888888888888888 ]],
  [[     "p888888888888888888888E~    ;t88888888888888888888888888;    :(88888888888888888888888888888888 ]],
  [[     "p888888888888888888888J       .(p8888888888888888888888o.      'lO88888888888888888888888888888 ]],
  [[     "p8888888888888888888882`        "%888888888888888888888p.        `P8888888888888888888888888888 ]],
  [[     "p8888888888888888888888}         .5888888888888888888888o,        `2888888888888888888888888888 ]],
  [[     "p88888888888888888888888Oc";.    `L8888888888888888888888Dn^;`    `V888888888888888888888888888 ]],
  [[     "p888888888888888888888888888Hdddd$888888888888888888888888888$dddd$8888888888888888888888888888 ]],
  [[     "p8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888 ]],
  [[     "p8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888 ]],
  [[     "p88888888#++++++++=ooU88888888bo>++++++++++++++++++To2O88888888%o=++++++++++++++++++++888888888 ]],
  [[      .````````.           .````````.                       .````````.                      ````````` ]],
}
local tool_2006_2019 = {
  [[           ;uRMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMgg%J'           ]],
  [[         `ABBBBBBBBBBR=`                                                                                                                         "kQBBBBBBBBBBBL          ]],
  [[         %BBBBBBBBBBB'                                                                                                                             %BBBBBBBBBBBB^         ]],
  [[         BBBBBBBBBBBB                                                                                                                              %BBBBBBBBBBBB2         ]],
  [[         BBBBBBBBBBBB                                                                                                                              %BBBBBBBBBBBB4         ]],
  [[        IBBBBBBBBBBBB5'                                                                                                                            %BBBBBBBBBBBB4         ]],
  [[ `i55w8QBBBBBBBBBBBBBBQRkww2~      :<x2Z55555555ZZZZZZZZZZZZZZZZ5555555555SjL=              rLCZZ5555555ZZZZZZZZZZZZZZZZZ555555555Z2J?,            %BBBBBBBBBBBB4         ]],
  [[ .;!!!rIgBBBBBBBBBBBBQe1+!!!`    "GBBBBBBBBBB8(r!!!!!!!!!!!!!!!!=/dBBBBBBBBBBBBt.        .IBBBBBBBBBBBE/+!!!!!!!!!!!!!!!+rygBBBBBBBBBBBk_          %BBBBBBBBBBBB4         ]],
  [[        ~BBBBBBBBBBBB"          !BBBBBBBBBBBM-                     8BBBBBBBBBBBB%       .OBBBBBBBBBBBT                     !RBBBBBBBBBBBB^         %BBBBBBBBBBBB4         ]],
  [[         BBBBBBBBBBBB           BBBBBBBBBBBBg                      ABBBBBBBBBBBBW!      /MBBBBBBBBBBB-                      OBBBBBBBBBBBBQ         %BBBBBBBBBBBB4         ]],
  [[         BBBBBBBBBBBB           BBBBBBBBBBBBW                      ABBBBBBBBBBBBM/      TNBBBBBBBBBBB-                      OBBBBBBBBBBBBB         %BBBBBBBBBBBB4         ]],
  [[         BBBBBBBBBBBB           BBBBBBBBBBBB&                      ABBBBBBBBBBBBM/      TQBBBBBBBBBBB-                      OBBBBBBBBBBBBB         %BBBBBBBBBBBB4         ]],
  [[         BBBBBBBBBBBB           BBBBBBBBBBBBR                      ABBBBBBBBBBBBM/      TQBBBBBBBBBBB-                      OBBBBBBBBBBBBB         %BBBBBBBBBBBB4         ]],
  [[         BBBBBBBBBBBB           BBBBBBBBBBBBR                      ABBBBBBBBBBBBM/      TQBBBBBBBBBBB-                      OBBBBBBBBBBBBB         %BBBBBBBBBBBB4         ]],
  [[         BBBBBBBBBBBB           BBBBBBBBBBBBR                      ABBBBBBBBBBBBM/      TQBBBBBBBBBBB-                      OBBBBBBBBBBBBB         %BBBBBBBBBBBB4         ]],
  [[         BBBBBBBBBBBB           BBBBBBBBBBBBR                      ABBBBBBBBBBBBg|      cNBBBBBBBBBBB-                      OBBBBBBBBBBBBB         %BBBBBBBBBBBB4         ]],
  [[         UBBBBBBBBBBB:          VBBBBBBBBBBBW                      %BBBBBBBBBBBB8'      ,RBBBBBBBBBBB!                     ~8BBBBBBBBBBBBl         %BBBBBBBBBBBBb         ]],
  [[         .2BBBBBBBBBBRr'         }BBBBBBBBBBBb!.                 "CBBBBBBBBBBBBN"        !QBBBBBBBBBBQ*_                 '=OBBBBBBBBBBBBf       .!UQBBBBBBBBBBBBBy!       ]],
  [[           _s8gMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMgMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMl` ]],
}
local tool_2019      = {
  [[                              .,~_"/???????????????????????????????<"         .,,.^!;`,,                  ,,`_!"`:,.                ."                                                            ]],
  [[                            !1?r;;;;;;;;;;;;;;;;;;;;;;;;;___rx______'       "x!~'..!  ,;1+~            '=/;, .=`.'_+l"              /=                                                            ]],
  [[                          !2/~.                             =w            "}=`    .!     :ry_        'Y|~     =.    '+s"            w=                                                            ]],
  [[                         =I_.                               =>;          1x;      .!      ."F=      =}".      =.      "j1          ;J=                                                            ]],
  [[                        !y!                                 =,L.        rC".      .!        +e!    !4r        =.      `+er        .*.=                                                            ]],
  [[ ~______________________?u;_________________________________*!!(________PC!_______;=        =iJ'  `T*=        /;_______+3P________f!;*__________________________________________________________~ ]],
  [[ !""""""""""""""""""""""""""""""""""""""""""""""""""""""""""+!""!"""^^^^!!"^^^^^^^""        fJ<'  '?Jf        !!!!!!!!!+r/!!!!!!!=!!!!"!!!!"!"""""""""!!!!!!!!!!!!!!+!!+ti!!!!!!!!""""""""""""""! ]],
  [[                                                            =,  `":     !>>.      .!        Pl;    ~IP        =.       |(<     :!~  .=                                 _o^                        ]],
  [[                                                            =,   .;"`   .!e_      .!       "4"`    `"4!       =.      _e/'    -;.   .=                                ~5+.                        ]],
  [[                                                            =,      _!-  .!V:     .!      "J;`      `;c"      =.     -er`  -"~      .=                               "2!'                         ]],
  [[                                                            =,        ,'"'_~!!:   .!    "T=`          `rT"    =.   :+r_~'"'~.       .=                           :_"c>,                           ]],
  [[                                                            =,            `'"<>/_!+T!~r!:.              `:!r_!J+!;>*?"-`            .?>>/>>>/>>>>//>>>>>><<<?????T!~`                             ]],
}
vim.cmd [[
hi StartLogo0 ctermfg=255 guifg=#FFFFFF
hi StartLogo1 ctermfg=18 guifg=#14067E
hi StartLogo2 ctermfg=18 guifg=#15127B
hi StartLogo3 ctermfg=18 guifg=#171F78
hi StartLogo4 ctermfg=18 guifg=#182B75
hi StartLogo5 ctermfg=23 guifg=#193872
hi StartLogo6 ctermfg=23 guifg=#1A446E
hi StartLogo7 ctermfg=23 guifg=#1C506B
hi StartLogo8 ctermfg=23 guifg=#1D5D68
hi StartLogo9 ctermfg=23 guifg=#1E6965
hi StartLogo10 ctermfg=29 guifg=#1F7562
hi StartLogo11 ctermfg=29 guifg=#21825F
hi StartLogo12 ctermfg=29 guifg=#228E5C
hi StartLogo13 ctermfg=35 guifg=#239B59
hi StartLogo14 ctermfg=35 guifg=#24A755
hi StartLogo15 ctermfg=35 guifg=#26B352
hi StartLogo16 ctermfg=35 guifg=#27C04F
hi StartLogo17 ctermfg=41 guifg=#28CC4C
hi StartLogo18 ctermfg=41 guifg=#29D343
hi StartLogoPop1 ctermfg=214 guifg=#EC9F05
hi StartLogoPop2 ctermfg=208 guifg=#F08C04
hi StartLogoPop3 ctermfg=208 guifg=#F37E03
hi StartLogoPop4 ctermfg=202 guifg=#F77002
hi StartLogoPop5 ctermfg=202 guifg=#FB5D01
hi StartLogoPop6 ctermfg=202 guifg=#FF4E00
]]

local function lineToStartGradient(lines)
  local out = {}
  for i, line in ipairs(lines) do
    table.insert(out, { hi = "StartLogo" .. i, line = line })
  end
  return out
end

local function lineToStartPopGradient(lines)
  local out = {}
  for i, line in ipairs(lines) do
    local hi = "StartLogo" .. i
    if i <= 6 then
      hi = "StartLogo" .. i + 6
    elseif i > 6 and i <= 12 then
      hi = "StartLogoPop" .. i - 6
    end
    table.insert(out, { hi = hi, line = line })
  end
  return out
end

local function lineToStartShiftGradient(lines)
  local out = {}
  for i, line in ipairs(lines) do
    local n = i
    if i > 6 and i <= 12 then
      n = i + 6
    elseif i > 12 then
      n = i - 6
    end
    table.insert(out, { hi = "StartLogo" .. n, line = line })
  end
  return out
end

local function lineToStartWhite(lines)
  local out = {}
  for i, line in ipairs(lines) do
    table.insert(out, { hi = "StartLogo" .. 0, line = line })
  end
  return out
end

local function lineToStartPop(lines)
  local out = {}
  local hi = "StartLogoPop" .. 1
  for i, line in ipairs(lines) do
    if i > 2 and i <= 4 then
      hi = "StartLogoPop" .. 2
    elseif i > 4 and i <= 6 then
      hi = "StartLogoPop" .. 3
    elseif i > 6 and i <= 8 then
      hi = "StartLogoPop" .. 4
    elseif i > 8 and i <= 10 then
      hi = "StartLogoPop" .. 5
    elseif i > 10 then
      hi = "StartLogoPop" .. 6
    end
    table.insert(out, { hi = hi, line = line })
  end
  return out
end
local cool = lineToStartPopGradient(coolLines)
local robust = lineToStartShiftGradient(robustLines)
local efficient = lineToStartGradient(efficientLines)



local logo_2001 = lineToStartWhite(tool_2001_2006)
local logo_2006 = lineToStartWhite(tool_2006_2019)
local logo_2019 = lineToStartPop(tool_2019)
local headers = { logo_2001, logo_2006, logo_2019, cool, robust, efficient }

local function header_chars()
  math.randomseed(os.time())
  return headers[math.random(#headers)]
end

local function header_color()
  local lines = {}
  for i, lineConfig in pairs(header_chars()) do
    local hi = lineConfig.hi
    local line_chars = lineConfig.line
    local line = {
      type = "text",
      val = line_chars,
      opts = {
        hl = hi,
        shrink_margin = false,
        position = "center",
      },
    }
    table.insert(lines, line)
  end

  local output = {
    type = "group",
    val = lines,
    opts = { position = "center", },
  }

  return output
end

local theme = require("alpha.themes.theta")
local config = theme.config
local dashboard = require("alpha.themes.dashboard")
local buttons = {
  type = "group",
  val = {
    { type = "text",    val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
    { type = "padding", val = 1 },
    dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "󰱼  > Find file", ":Telescope find_files<CR>"),
    dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
    dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
    dashboard.button("u", "󰚥  > Update Plugins", ":PackerUpdate<CR>"),
    dashboard.button("q", "󰩈  > Quit NVIM", ":qa<CR>"),
  },
  position = "center",
}

config.layout[2] = header_color()
config.layout[6] = buttons
alpha.setup(config)
