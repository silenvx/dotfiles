#!/bin/sh
cd "$(dirname ${0})"
VERSION='0.0.3'
FLAG_mode=''
FLAG_f=''
FLAG_v=''
SYM_FUNCARG=''
# このファイルを見ながらファイルを設置したり-sの時にコメントを出力したりする
SYM_FILELIST="./.setsymlist"
# 関数をまとめたファイル
SYM_FUNC="./.setsymfunc.sh"
# dotfilesを置くディレクトリ。-sか-gの時のみ使用。今のところは./から始まる値を書いてください。気が向いたらいじります
SYM_DOTFILES="./misc"
# -gの時に無視したいファイルを取得するのに使う
SYM_IGNOREFILE="./.gitignore"
# ${SYM_FILELIST}の最後の行に使うコメントの文字列を指定する。面倒なのでgrepの対策はしてないです
SYM_LISTEOF='# vim: set filetype=conf:'

# ヘルプ関数{{{
func_help(){
    cat << __EOF__
${0##*/} version:${VERSION}
このコマンドの使い方
-i          シンボリックリンクを設置
-r          シンボリックリンクを削除
-if         強制的に設置 (既にファイルがある場合は消す、ディレクトリがない場合は作ります)
-rf         強制的に削除 (設置してなさそうなシンボリックリンクでも消す)
-l <file>   シンボリックリンクを貼るリストが書いてあるファイルを指定 (通常はこのファイルのある場所の.symfilelist)
-s          .symfilelistに書けそうな物を出力する
-g          .gitignoreに書けそうな物を出力する
-v          よくあるverbose。要はこれがあると詳細な出力を-iや-rなどの時にします
-t          テスト(デバッグ)用のオプション
-h          このヘルプを表示
----------
例: ${0##*/} -if -l ${SYM_FILELIST}
----------
注意:-sと-gの時に直接.symfilelistや.gitignoreにリダイレクト(出力)しないこと。ほとんどの場合は消えます
回避するには一時的に適当なファイルに出力した後にmvさせる
__EOF__
    exit 0
}
# }}}ヘルプ関数
# オプション判定{{{
if [ "${#}" -lt "1" ];then
    func_help >&2
fi

unset GETOPT_COMPATIBLE
OPT=`getopt -o irfl:sgvth -- "${@}"`
if [ "${?}" != 0 ];then
    func_help >&2
    exit 1
fi

eval set -- "${OPT}"

j=0
for i;do
    case ${i} in
        -i)
            FLAG_mode='install'
            j=`expr "${j}" + 1`
            ;;
        -r)
            FLAG_mode='remove'
            j=`expr "${j}" + 1`
            ;;
        -f)
            FLAG_f='true'
            ;;
        -l)
            SYM_FILELIST="${2}"
            shift
            ;;
        -s)
            FLAG_mode='search'
            j=`expr "${j}" + 1`
            ;;
        -g)
            FLAG_mode='ignore'
            j=`expr "${j}" + 1`
            ;;
        -v)
            FLAG_v='true'
            ;;
        -t)
            FLAG_mode='test'
            j=`expr "${j}" + 1`
            ;;
        -h)
            func_help
            ;;
        --)
            break
            ;;
    esac
    shift
done
# }}}オプション判定
# 初期エラーチェック{{{
if [ "${j}" != '1' ];then
    echo "-i, -r, -s, -g, -tのどれか1つだけを指定してください" >&2
    exit 1
fi

if [ ! -f "${SYM_FILELIST}" ];then
    echo "${SYM_FILELIST}がファイルではありません: 対象のファイルを書くファイルです" >&2
    exit 1
fi

if [ ! -f "${SYM_FUNC}" ];then
    echo "${SYM_FUNC}がファイルではありません: 処理を書くファイルです" >&2
    exit 1
fi
source "${SYM_FUNC}"


#}}}初期エラーチェック
# ${SYM_FILELIST}を必要としない処理を実行{{{
func_setsym_dotfiles_check(){ #{{{
    if [ ! -d  "${SYM_DOTFILES}" ];then
        echo "${SYM_DOTFILES}がディレクトリではありません: dotfilesを置くディレクトリです" >&2
        exit 1
    fi
    SYM_DOTFILES=$(echo "${SYM_DOTFILES}"|sed -e 's/\(\.\|\*\|\^\|\$\|\\\|\/\|\[\|\]\)/\\\1/g')
} #}}}
case ${FLAG_mode} in
    search)
        func_setsym_dotfiles_check
        grep -v "^${SYM_LISTEOF}" "${SYM_FILELIST}"|grep '^ *#' && printf '\n'
        IFS=$'\n'
        for i in ${SYM_FUNCLIST};do
            eval func_search_${i%% *}
            printf '\n'
        done
        echo "${SYM_LISTEOF}"
        exit 0
        ;;
    ignore)
# gitignoreに使用する文字列の生成{{{
        func_setsym_dotfiles_check
        SYM_IGNORELIST=`grep -v '^\(!.*\|/\*\|/\.\*\|\)$' "${SYM_IGNOREFILE}"`
        SYM_IGNOREFIND="find ${SYM_DOTFILES} -type f"
        printf '/*\n/.*\n\n'
        IFS=$'\n'
        for i in ${SYM_IGNORELIST};do
            SYM_IGNOREFIND="${SYM_IGNOREFIND} -and ! -path '.${i}/*'"
        done
        for i in `eval "${SYM_IGNOREFIND% -and}"`;do
            echo "${i}"|sed -e 's/^.\//\//g' -e 's/^/!/g'
        done
        printf '\n'
        echo "${SYM_IGNORELIST}"
        exit 0
# }}}gitignoreに使用する文字列の生成
        ;;
esac
# }}}${SYM_FILELIST}を必要としない処理を実行
# ${SYM_FILELIST}の構文チェック{{{
l=1
LINE=`cat "${SYM_FILELIST}"|grep -v '^$'|wc -l`
IFS=$'\n'
for i in `cat "${SYM_FILELIST}"`;do
# TODO:verbose時にカウンターを表示したくなければ下のif文をコメントアウトする
#    if [ "${FLAG_v}" != 'true' ];then
        printf "\ranalyze: ${l}/${LINE} "
        l=`expr "${l}" + 1`
#    fi
    echo "${i}"|grep -v "^#" >/dev/null 2>&1
    if [ "${?}" == 0 ];then
        SYM_FUNCARG=''
        IFS=$'\n'
        for n in ${SYM_FUNCLIST};do
            if [ "${i%% *}" == "${n%% *}" ];then
                SYM_FUNCARG="${n##* }"
            fi
        done
        if [ "${SYM_FUNCARG}" == '' ];then
            echo "${SYM_FILELIST}の`grep -n \"^${i}$\" \"${SYM_FILELIST}\"`に誤りがありました" >&2
            echo "${i%% *}の処理は設定されていません" >&2
            exit 1
        fi
        k='0'
        IFS=' '
        for j in ${i};do
            if [ "${k}" -gt "${SYM_FUNCARG}" ];then
                echo "${SYM_FILELIST}の`grep -n \"^${i}$\" \"${SYM_FILELIST}\"`に誤りがありました" >&2
                echo "値の数が多いです" >&2
                exit 1
            fi
            echo "${j}"|grep "^'.*'$" >/dev/null 2>&1
            k=`expr ${k} + 1`
        done
        if [ "${k}" == "${SYM_FUNCARG}" ];then
            echo "${SYM_FILELIST}の`grep -n \"^${i}$\" \"${SYM_FILELIST}\"`に誤りがありました" >&2
            echo "値の数が少ないです" >&2
            exit 1
        fi
        if [ -z "${SYM_LIST}" ];then
            SYM_LIST="${i}"
        else
            SYM_LIST="${SYM_LIST}"$'\n'"${i}"
        fi
    fi
    IFS=$'\n'
done
# }}}${SYM_FILELIST}の構文チェック
# ${SYM_FILELIST}などが必要な処理を実行{{{
if [ -n "${FLAG_mode}" ];then
    printf '\n'
    C='1'
    LINE=`echo "${SYM_LIST}"|wc -l`
    IFS=$'\n'
    for i in ${SYM_LIST};do
# TODO:verbose時にカウンターを表示したくなければ下のif文をコメントアウトする
#        if [ "${FLAG_v}" != 'true' ];then
            printf "\rrun: ${C}/${LINE} "
            C=`expr "${C}" + 1`
#        fi
        eval func_${FLAG_mode}_${i%% *} ${i#* }
    done
    printf '\n'
fi
# }}}${SYM_FILELIST}などが必要な処理を実行

# vim: set fdm=marker:
