local tool_logo = {}

local sample = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]

local tool_1992_2001 = [[
IBYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYBI 
Iz                                                                                                                      zI 
Iz                                                                                                                      zI 
Iz    ..........................      ..............-               ................       ..............               zI 
Iz   (WNM#HH#HHHHH##H#H#HH##MMMR_ .-jHM###########HHMNmJ.       .(gMMMHH####H#H###MMNa..  .W##H#H#H#MMM#:               zI 
Iz   (H#HHHHHMHHHHHMMHHH#H#HH#MD-(HMMM#HHHHMMMMHHHH#HHH#MH+   .jHM#HHH#H#MMMMM#MHMHHH#MN&..W#MHHHHHHHH##;               zI 
Iz   (WMMMMMMMHH#HHMMHH#MMMMMMMSdMMHHHMHHM9=!~_?TMMHHHHHH#N{ .dMMM#M##MMY?~  _?MMHHHHHH#N{.TMM#HHHHHHH##!               zI 
Iz          (XHHHHHHMH#M>      .dMHHHMH##N:      dMHHHHHHHN} .dHM#HMHHMN_      dMHHHHHH#N{  (d#HHHHHHH##!               zI 
Iz           d##HH#H#H#M:      .dM#HHMHH#N:      dMHHHHHH#N}  d##HHHHH#N:      dMHHH#HH#N{  -XMHHHHHHH##:               zI 
Iz           X#H#M#HMH#M>       d#HHHHHH#N:      d#HHHHHH#N} .dHHH#HH##N:      dMHHHHHH#N{  -dMMH#HHHH##!               zI 
Iz           X#HHHHHMH#M>       dHHHHMHH#N:      d#HH#HHH#N} .dH##HMHH#N!      dMHHHHHH#N{  -d#HHHHHHH##:               zI 
Iz           X##MMHHHHHM>      .dHHHHMMHMN:      dMHMH#HH#N} .dHH#HH#HMN!      dMHMMHMHNN{  .dMHHMMMHMM#;   (((((J.     zI 
Iz           XHH#MHMH#HMe,      d#HHHHHHHN>     .dMHMM#HH#N} .dH#MHHMHMN+     .dM#MMH#H#N{  (dM#HHHHHH#N&..(W##MMMl     zI 
Iz           X##HHHMHHM#Mb      ZM#MHHHHMMNmg++gMMMMMHHHMM#>  ?M#MMMMHHMNmagjgM##H#M#M#M@:  (dM#HHHHHH#H#MMMHMHHHMl     zI 
Iz           XM#H#####MHMD       ?TMMH#MHMH#H#HHHHHHMMHM#Y!    _TMMMHHMHH#HH#M#MMMMNHMB3    -d###MM######MH###M#NMl     zI 
Iz           XM#H#####MHMD          ?7TMMMMMMMMMMMMMBY7~          _?TTMMMMMMMMMMMHY=!        ?<<<<<<<<<<<<<<<<<<?<      zI 
Iz                                                                                                                      zI 
Iz                                                                                                                      zI 
Ib                                                                                                                      dI 
IBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXkBI ]]

-- FIXME: 横幅が合わないので、適当に調整する
local tool_2001_2006 = [[
     __/*                                                                                 '_1*G 
     .!|}%pO888.                                                                           .|/wq$8888 
     >888888888.                                                                           e888888888 
 """"}888888888!""""`                                                                      e888888888 
 888888888888888888p"                                                                      e888888888 
 ||||I$88888888>|||r'               .?4kkkL;                         :/Pkkk|,              e888888888 
     "p88888888.                 _<%888888882"                    `TP88888888C_            e888888888 
     "p88888888.               !k8888888888888y.               .=98888888888888u           e888888888 
     "p88888888699999999999999p8888888888888888ppppppppppppppppd8888888888888888p9999999999$888888888 
     "p888888888888888888888881-,388888888888888888888888888888+,-t8888888888888888888888888888888888 
     "p888888888888888888888E~    ;t88888888888888888888888888;    :(88888888888888888888888888888888 
     "p888888888888888888888J       .(p8888888888888888888888o.      'lO88888888888888888888888888888 
     "p8888888888888888888882`        "%888888888888888888888p.        `P8888888888888888888888888888 
     "p8888888888888888888888}         .5888888888888888888888o,        `2888888888888888888888888888 
     "p88888888888888888888888Oc";.    `L8888888888888888888888Dn^;`    `V888888888888888888888888888 
     "p888888888888888888888888888Hdddd$888888888888888888888888888$dddd$8888888888888888888888888888 
     "p8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888 
     "p8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888 
     "p88888888#++++++++=ooU88888888bo>++++++++++++++++++To2O88888888%o=++++++++++++++++++++888888888 
      .````````.           .````````.                       .````````.                      ````````` ]]

local tool_2006_2019 = [[

         ............................................................................................................      
      .MMMMMMMMB"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""WMMMMMMMMN&     
      MMMMMMMMM                                                                                             ,MMMMMMMMMb    
      MMMMMMMMM                                                                                             ,MMMMMMMMM#    
     .MMMMMMMMM,                                                                                            ,MMMMMMMMM#    
....JMMMMMMMMMMMg...,     ................................          ................................        ,MMMMMMMMM#    
???"MMMMMMMMMMM"???`   .MMMMMMMM#"?????????????TMMMMMMMMMN,      .MMMMMMMMM"7????????????7WMMMMMMMMMe       ,MMMMMMMMM#    
     MMMMMMMMM:       .MMMMMMMMM                .MMMMMMMMMN.    .MMMMMMMMM%                MMMMMMMMMM]      ,MMMMMMMMM#    
     MMMMMMMMM_       gMMMMMMMMN                .MMMMMMMMMM)    ,MMMMMMMMM[                dMMMMMMMMMF      ,MMMMMMMMM#    
     MMMMMMMMM_       gMMMMMMMMN                .MMMMMMMMMM)    ,MMMMMMMMM[                dMMMMMMMMMF      ,MMMMMMMMM#    
     MMMMMMMMM_       gMMMMMMMMN                .MMMMMMMMMM)    ,MMMMMMMMM[                dMMMMMMMMMF      ,MMMMMMMMM#    
     MMMMMMMMM_       gMMMMMMMMN                .MMMMMMMMMM)    ,MMMMMMMMM[                dMMMMMMMMMF      ,MMMMMMMMM#    
     MMMMMMMMM_       gMMMMMMMMN                .MMMMMMMMMM)    ,MMMMMMMMM[                dMMMMMMMMMF      ,MMMMMMMMM#    
     HMMMMMMMM,       (MMMMMMMMN.               .MMMMMMMMMM`    .MMMMMMMMM]                dMMMMMMMMMF      .MMMMMMMMMN    
      TMMMMMMMMg.......dMMMMMMMMNa.............JMMMMMMMMMMa.......MMMMMMMMMN..............MMMMMMMMMMN......&MMMMMMMMMMMNJ..
        """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

]]

-- FIXME: 横幅が合わないので、適当に調整する
local tool_2019 = [[
                        ...........................         ....                ....              .}                                              
                    .d9=<???????????????????<2!!!!!     .J=! .! ?Ta,        .-Y^`.] ?7n,          .}                                              
                   .d=                       .N        .d=    ,~    ?m.     J5`   .r    ?N,        d}                                             
                  .H{                        .Z;      .#>     ,~     ?N.   d$`    .r     (M,      .0}                                             
 .................(K..........................lj......dh-......~     (d]  .#>     .r......XN......2({............................................ 
 7????????????????????<??<<<<<<<<<<<<<<<<????<2?1/????1u/?????<~     (K\  ,Xr     .r?????<QZ????<2?1<???????????????<<<<<<<<<<d2<<??????????????? 
                                             .)  ?+   .dL     ,~     d3`   zN.    .r     .@>   .=  ,}                        .#!                  
                                             .)    7.. _d&    ,~    (5`     ?b.   .r    .@>  .7    ,}                       .#>                   
                                             .)      (=(.?S,  ,~  .Y!        (4.. .r  .J3(.?^      ,}                   ...V=`                    
                                             .'           !??77=7!              ?77"77!!`          .7<<<<<<<<<?7777777777!`                       ]]

local char_headers = { tool_1992_2001, tool_2001_2006, tool_2006_2019, tool_2019 }

local function random_logo()
  -- Pick Logo randomly
  math.randomseed(os.time())
  local picked_logo = char_headers[math.random(#char_headers)]
  return picked_logo
end

tool_logo.random_logo = random_logo

return tool_logo
