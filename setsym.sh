#!/bin/sh
VERSION="0.0.2"
PWD="$(cd $(dirname ${0});pwd)"
FLAG_i="false"
FLAG_r="false"
FLAG_f="false"
SYM_FUNCARG=""
# このファイルを見ながらファイルを設置する
SYM_FILELIST="./.setsymlist"
# 関数をまとめたファイル
source "./.setsymfunc.sh"

# ヘルプ関数{{{
func_help(){
    echo "${0##*/} version:${VERSION}"
    echo "このコマンドの使い方"
    echo "-i        シンボリックリンクを設置"
    echo "-r        シンボリックリンクを削除"
    echo "-if       強制的に設置 (既にファイルがある場合は消す、ディレクトリがない場合は作ります)"
    echo "-rf       強制的に削除 (設置してなさそうなシンボリックリンクでも消す)"
    echo "-l <file> シンボリックリンクを貼るリストが書いてあるファイルを指定 (通常は./.symfilelist)"
    echo "-h        このヘルプを表示"
    echo "----------"
    echo "例: ${0##*/} -if -l ${SYM_FILELIST}"
    exit 0
}
# }}}ヘルプ関数
# オプション判定{{{
if [ "${#}" -lt "1" ];then
    func_help >&2
fi

unset GETOPT_COMPATIBLE
OPT=`getopt -o irfl:h -- "${@}"`
if [ "${?}" != 0 ];then
    func_help >&2
    exit 1
fi

eval set -- "${OPT}"

for i;do
    case ${i} in
        -i) FLAG_i="true";;
        -r) FLAG_r="true";;
        -f) FLAG_f="true";;
        -l) SYM_FILELIST="${2}"
            shift;;
        -h) func_help;;
        --) break;;
    esac
    shift
done
# }}}オプション判定
# オプションのエラーチェック{{{
if [ "${FLAG_i}" == "false" -a "${FLAG_r}" == "false" ];then
    echo "-iまたは-rのどちらかを有効にしてください" >&2
    exit 1
elif [ "${FLAG_i}" == "true" -a "${FLAG_r}" == "true" ];then
    echo "-iまたは-rのどちらかを無効にしてください" >&2
    exit 1
fi

if [ ! -e "${SYM_FILELIST}" ];then
    echo "${SYM_FILELIST}が存在しません" >&2
    exit 1
fi
#}}}オプションのエラーチェック
# ${SYM_FILELIST}の構文チェック{{{
IFS=$'\n'
for i in `cat "${SYM_FILELIST}"`;do
    echo "${i}"|grep -v "^#" >/dev/null 2>&1
    if [ "${?}" == 0 ];then
        IFS=$'\n'
        for n in ${SYM_FUNCLIST};do
            if [ "${i%% *}" == "${n%% *}" ];then
                SYM_FUNCARG="${n##* }"
            fi
        done
        if [ "${SYM_FUNCARG}" == "" ];then
            echo "${SYM_FILELIST}の`grep -n \"^${i}$\" \"${SYM_FILELIST}\"`に誤りがありました" >&2
            echo "${i%% *}の処理は設定されていません" >&2
            exit 1
        fi
        k="0"
        IFS=" "
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
# 処理実行{{{
if [ "${FLAG_i}" == "true" -o "${FLAG_r}" == "true" ];then
    if [ "${FLAG_i}" == "true" -a "${FLAG_r}" == "false" ];then
        FLAG_mode="install"
    elif [ "${FLAG_i}" == "false" -a "${FLAG_r}" == "true" ];then
        FLAG_mode="remove"
    else
        exit 1
    fi
    IFS=$'\n'
    for i in ${SYM_LIST};do
        IFS=" "
        func_${FLAG_mode}_${i%% *} ${i#* }
        IFS=$'\n'
    done
fi
# }}}処理実行

# vim: set fdm=marker:
