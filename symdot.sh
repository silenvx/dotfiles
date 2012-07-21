#!/bin/sh
# 2012/06/17 - 2012/06/19 UTF-8 LF

# 現在のバージョン
VERSION="0.0.3-r3"

# このファイルの場所
PWD="$(cd $(dirname ${0});pwd)"

# ホームディレクトリに張りたいファイル名を書く
# 改行だけの行があるとcleanした時にホームディレクトリごと消滅したので注意(修正しました)
HOME_DOTFILES=${HOME_DOTFILES:=".emacs
    .fbtermrc
    .fonts.conf
    .screenrc
    .tmux.conf
    .uim
    .vim
    .vimperator
    .vimperatorrc
    .vimrc
    .xinitrc
    .Xresources
    .zshenv
    .zshrc
    .wgetrc"}

# 自動的に行うコマンドで無視したいファイル名やディレクトリ名を
# grepの正規表現を使って書く
# miscはホームディレクトリ以外にシンボリックリンクを張りたいファイルを置く場所
# install rootをするとmisc/rootはルートディレクトリのように見立てて
# シンボリックリンクが貼られていく
IGNORE_FILES=${IGNORE_FILES:="^\.$
    ^\.\.$
    ^\.git$
    ^README\.md$
    ^symdot\.sh$
    ^\.gitignore$
    ^\.gitmodules$
    ^misc$"}

func_help(){
    echo "${0##*/} version:${VERSION}"
    echo "misc/root以下はchown -R root:rootすべきです"
    echo "--------------"
    echo "オプション"
    echo " help             このヘルプを表示"
    echo " install          HOME_DOTFILESを見ながらシンボリックリンクを設置"
    echo " clean            HOME_DOTFILESを見ながらシンボリックリンクを削除"
    echo " pretend          どこがいじられるか表示"
    echo " candidate        HOME_DOTFILESに追加できそうな候補を表示"
    echo " install auto     candidateの出力だけを見ながらシンボリックリンクを削除"
    echo " clean auto       candidateの出力だけを見ながらシンボリックリンクを削除"
    echo " install root     misc/root以下のファイルを見てルートディレクトリ以下にシンボリックリンクを設置"
    echo " clean root       misc/root以下のファイルを見てルートディレクトリ以下のシンボリックリンクを削除"
    echo "--------------"
    echo "HOME_DOTFILESの影響を受けるオプション"
    echo " install clean pretend"
    echo
    echo "IGNORE_FILESの影響を受けるオプション"
    echo " candidate auto"
}

func_install(){
    echo "${HOME_DOTFILES}"|\
        while read TMP
    do
        if [ "${TMP}" != "" ];then
            if [ -e "${HOME}/${TMP}" ];then
                echo "既に~/${TMP}が存在します"
            else
                echo "installing ~/${TMP}"
                ln -s "${PWD}/${TMP}" "${HOME}/${TMP}"
            fi
        else
            echo "名前が指定されていない行をスキップしました"
        fi
    done
}

func_clean(){
    echo "${HOME_DOTFILES}"|\
        while read TMP
    do
        if [ "${TMP}" != "" ];then
            ls -l1ad "${HOME}/${TMP}" 2>/dev/null|grep "^l" > /dev/null 2>&1
            if [ "${?}" == "0" ];then
                echo "clealing ~/${TMP}"
                rm "${HOME}/${TMP}"
            else
                echo "not symbolic link: ~/${TMP}"
            fi
        else
            echo "名前が指定されていない行をスキップしました"
        fi
    done
}

func_pretend(){
    echo "${HOME_DOTFILES}"|\
        while read TMP
    do
        echo "pretend ${PWD}/${TMP} -> ${HOME}/${TMP}"
    done
}

func_candidate(){
    LS=$(ls -1a ${PWD})
    for TMP in $(echo "${IGNORE_FILES}")
    do
        LS=$(echo "${LS}"|grep -ve "${TMP}")
    done
    echo "${LS}"
}

func_install_auto(){
    HOME_DOTFILES=$(func_candidate)
    func_install
}

func_clean_auto(){
    HOME_DOTFILES=$(func_candidate)
    func_clean
}

func_search_misc_root(){
    if [ -d "${PWD}/misc/root" ];then
        MISC_ROOT_FILES=$(echo "$(cd ${PWD}/misc/root;find ./ -type f -print)"|\
                sed -e "s/^\.//g")
    else
        echo "${PWD}/misc/rootディレクトリが見つかりません"
        exit 1
    fi
}

func_install_misc_root(){
    func_search_misc_root
    echo "${MISC_ROOT_FILES}"|\
        while read TMP
    do
        if [ "${TMP}" != "" ];then
            if [ -e "${TMP}" ];then
                echo "既に${TMP}が存在します"
            else
                echo "installing ${TMP}"
                ln -s "${PWD}/misc/root${TMP}" "${TMP}"
            fi
        else
            echo "名前が指定されていない行をスキップしました"
        fi
    done
}

func_clean_misc_root(){
    func_search_misc_root
    echo "${MISC_ROOT_FILES}"|\
        while read TMP
    do
        if [ "${TMP}" != "" ];then
            ls -l1ad "${TMP}" 2>/dev/null|grep "^l" > /dev/null 2>&1
            if [ "${?}" == "0" ];then
                echo "cleaning ${TMP}"
                rm "${TMP}"
            else
                echo "not symbolic link: ${TMP}"
            fi
        else
            echo "名前が指定されていない行をスキップしました"
        fi
    done
}

# main routine
if [ "${#}" == "0" ];then
    func_help
else
    if [ "${1}" == "help" ];then
        func_help
    elif [ "${1}" == "install" ];then
        if [ "${2}" == "auto" ];then
            func_install_auto
        elif [ "${2}" == "root" ];then
            func_install_misc_root
        else
            func_install
        fi
    elif [ "${1}" == "clean" ];then
        if [ "${2}" == "auto" ];then
            func_clean_auto
        elif [ "${2}" == "root" ];then
            func_clean_misc_root
        else
            func_clean
        fi
    elif [ "${1}" == "pretend" ];then
        func_pretend
    elif [ "${1}" == "candidate" ];then
        echo "---candidate---"
        func_candidate
    else
        echo "unknown option argument: ${1}"
    fi
fi

