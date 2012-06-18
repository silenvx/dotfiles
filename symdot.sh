#!/bin/sh
# 2012/06/17 UTF-8 LF

# 現在のバージョン
VERSION="0.0.2"
# このファイルの場所
PWD=$(cd $(dirname ${0});pwd)
# ホームディレクトリに張りたいファイル名を書く
# 最初のところに改行を入れちゃうとcleanした時にホームディレクトリごと消滅したので注意
HOME_DOTFILES=".emacs
.fbtermrc
.fonts.conf
.screenrc
.tmux.conf
.uim
.vimperatorrc
.vimrc
.xinitrc
.Xresources
.zshrc"
# 自動的に行うコマンドで無視したいファイル名やディレクトリ名を
# grepの正規表現を使って書く
# miscはホームディレクトリ以外にシンボリックリンクを張りたいファイルを置く場所(現在は未実装)
IGNORE_FILES="^\.$
^\.\.$
^\.git$
^README\.md$
^symdot\.sh$
^\.gitignore$
^misc$"

func_help(){
    echo "${0##*/} version:${VERSION}"
    echo "--------------"
    echo "option"
    echo " help         このヘルプを表示"
    echo " install      シンボリックリンクを設置"
    echo " clean        シンボリックリンクを削除"
    echo " pretend      どこに何がインストールされるか表示"
    echo " candidate    HOME_DOTFILESに追加できそうな候補を表示"
    echo " auto         候補のシンボリックリンクを設置"
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
            echo "install ~/${TMP}"
            ln -s ${PWD}/${TMP} ~/${TMP}
        done
    }

    func_clean(){
        echo "${HOME_DOTFILES}"|\
            while read TMP
            do
                echo "clean ~/${TMP}"
                rm ~/${TMP}
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
                    LS=$(echo "${LS}"|grep -ve ${TMP})
                done
                echo "${LS}"
            }

            func_auto(){
                func_candidate|\
                    while read TMP
                    do
                        echo "auto ~/${TMP}"
                        ln -s ${PWD}/${TMP} ~/${TMP}
                    done
                }

                if [ $# == "0" ];then
                    func_help
                else
                    if [ ${1} == "help" ];then
                        func_help
                    elif [ ${1} == "install" ];then
                        func_install
                    elif [ ${1} == "clean" ];then
                        func_clean
                    elif [ ${1} == "pretend" ];then
                        func_pretend
                    elif [ ${1} == "candidate" ];then
                        echo "---candidate---"
                        func_candidate
                    elif [ ${1} == "auto" ];then
                        func_auto
                    else
                        echo "unknown option argument: ${1}"
                    fi
                fi

