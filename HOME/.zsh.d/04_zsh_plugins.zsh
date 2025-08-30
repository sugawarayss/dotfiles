if type brew > /dev/null 2>&1; then
  ###########################
  # zsh-completions         #
  # zsh-autosuggestions     #
  ###########################
  FPATH=${BREWPREFIX}/share/zsh-completions:$FPATH
  source ${BREWPREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  autoload -Uz compinit && compinit

  ###########################
  # zsh-syntax-highlighting #
  ###########################
  source ${BREWPREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  # 6type syntax highlight
  #    main     : 基本ハイライト。デフォルトではこれのみ有効
  #    brackets : 括弧
  #    pattern  : ユーザ定義
  #    cursor   : カーソル
  #    root     : rootユーザの場合にコマンドライン全体に適用
  #    line     : コマンドライン全体に適用
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)

  # main config
  # Declare the variable
  typeset -A ZSH_HIGHLIGHT_STYLES
  # エイリアスコマンドのハイライト
  ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
  # 存在するパスのハイライト
  ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
  # グロブ
  ZSH_HIGHLIGHT_STYLES[globbing]='none'

  # brackets
  # マッチしない括弧
  ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red,bold'
  # 括弧の階層
  ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=cyan,bold'
  # カーソルがある場所の括弧にマッチする括弧
  ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='standout'

  # cursor
  ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'
fi