# PROMPT{{{
PROMPT="%B%{[34m%}[%*] %{[32m%}%n@%m %{[37m%}%# %{[m%}%b" #  通常のプロンプト
PROMPT2="%B%_>%b" # 二行目以降に表示されるプロンプト
RPROMPT="%B%{[33m%}[%c]%{[m%}%b" # 右側に表示されるプロンプト
# }}}PROMPT
# lsでカラー表示をする
alias ls='ls --color=auto'
# 単語の区切りではない文字を指定する
export WORDCHARS="*?_-.[]~=&;!# $%^(){}<>"
# pathを設定
export PATH="$PATH:$HOME/bin:$HOME/local/bin"
# editor
export EDITOR="vim"
# browser
export BROWSER="w3m"
# 履歴をファイルに保存する
HISTFILE=$HOME/.zsh_history
# メモリ内の履歴の数
HISTSIZE=100000
# 保存される履歴の数
SAVEHIST=100000
# 補完するときに溢れそうなら尋ねる
LISTMAX=0
# ファイル作成時のパーミッション
umask 022
# 補完関連
autoload -Uz compinit
compinit -u
# 文字列関連
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified
# dircolors load
if [ -f ~/.dir_colors ];then
    eval `dircolors -b ~/.dir_colors`
fi
# zstyle completion{{{
# 小文字だけなら大文字と区別しない。大文字の場合は区別する
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# #  一部のコマンドライン定義は、展開時に時間のかかる処理を行う -- apt-get, dpkg (Debian), rpm (Redhat), urpmi (Mandrake), perlの-Mオプション, bogofilter (zsh 4.2.1以降), fink, mac_apps (MacOS X)(zsh 4.2.2以降)
zstyle ':completion:*' use-cache true
# 補完対象が多いと一覧を表示して選択ができるようにする
zstyle ':completion:*:default' menu select=1
# 補完にLS_COLORSの色をつける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# sudoしたい時の補完候補を増やす (コメントアウトしてもなぜか動くので様子見)
#zstyle ':completion:*:sudo:*' command-path /usr/local/bin /usr/bin /bin /opt/bin /usr/local/sbin /usr/sbin /sbin
# killのプロセスの補完をカスタマイズ
# zstyle ':completion:*:*:kill:*:processes' command 'ps x -o pid,etime,state,comm,args'
zstyle ':completion:*:processes' command 'ps x -o pid,etime,stat,sgi_p,comm,args'
# }}}zstyle completion
# bindkey{{{
# キーバインドをemacs風にする
bindkey -e
# コマンドの履歴の検索でパターン検索ができるようになる
if zle -la | grep -q '^history-incremental-pattern-search'; then
    #  zsh 4.3.10 以降でのみ有効
    bindkey '^R' history-incremental-pattern-search-backward
    bindkey '^S' history-incremental-pattern-search-forward
fi
# delete key を使えるよにする
bindkey "^[[3~" delete-char
# Shift-Tabで補完候補を逆順にする
bindkey "^[[Z" reverse-menu-complete
# }}}bindkey
# setopt {{{
# setopt 補完関連{{{
# 補完候補を一覧表示(TABを1回押したら出る奴で選択できる奴とは別)
setopt auto_list
# TABで順番に補完候補が切り替わる(TABを2回押したら出る奴で選択できる奴)
setopt auto_menu
# 補完候補が複数あった場合にすぐ選択できるやつに切り替えるのを無効にしとく
unsetopt menu_complete
# 補完候補がたくさんあったらなるべくを詰めて表示する
setopt list_packed
# 補完候補一覧でファイルの種類がわかるようにマークを表示する
setopt list_types
# 補完候補で日本語が正しく表示されるらしい
setopt print_eight_bit
# --prefix=/usrなどの=以降も補完
setopt magic_equal_subst
# }}}setopt 補完関連
# setopt 履歴関連{{{
# 履歴ファイルに時刻を記録する
setopt extended_history
# 履歴を共有する
setopt share_history
# 重複するコマンドを保存しない
setopt hist_ignore_all_dups
# コマンドがスペースで始まる場合はヒストリしない
setopt hist_ignore_space
# historyコマンドは履歴に登録しない
setopt hist_no_store
# 余分な空白は詰めて記録
setopt hist_reduce_blanks
# 履歴展開で直接コマンドを実行せずに編集可能な状態にする
setopt hist_verify
# }}}setopt 履歴関連
# beeo音が鳴らなくなる
setopt no_beep
# ^Dでログアウトしなくなる
setopt ignore_eof
# cdをpushdに置き換える
setopt auto_pushd
# pushdで同じディレクトリを重複してpushしない
setopt pushd_ignore_dups
# {a-c}を a b c に展開するようにする
setopt brace_ccl
# ファイル名で #, ~, ^ の3文字を正規表現として扱う
setopt extended_glob
# 最後のスラッシュを自動的に削除しない
setopt noautoremoveslash
# 無駄なスクロールを避ける
setopt always_last_prompt
# 改行のない出力をプロンプトで上書きするのを防ぐ
setopt promptcr
# C-sでフロー制御を禁止にする(C-qで出れる) 代わりにヒストリの検索ができる
setopt noflowcontrol
# シェル終了時にバックグラウンドなどがあれば警告する
setopt check_jobs
# コマンドラインでも# 以降をコメントとする
setopt interactive_comments
# 辞書順ではなく数値順でソート
setopt numeric_glob_sort
# }}}setopt

# fbtermを起動したらTERMをfbtermに変更 (patchを当てることによって不要になった)
#if grep '^fbterm' /proc/$PPID/cmdline > /dev/null; then
#
#    export TERM=fbterm
#fi

# vim:set fdm=marker:
