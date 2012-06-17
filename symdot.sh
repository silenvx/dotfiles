#!/bin/sh
#ホームディレクトリに張りたいファイル名を書く
HOME_DOTFILES="
.emacs\n
.fbtermrc\n
.fonts.conf\n
.screenrc\n
.tmux.conf\n
.uim\n
.vimperatorrc\n
.vimrc\n
.xinitrc\n
.Xresources\n
.zshrc"
PWD=$(cd $(dirname ${0});pwd)
if [ $# == "0" ]
then
    echo "please, ${0##*/} help"
else
    if [ ${1} == "help" ]
    then
        echo "${0##*/} version:0.0.1"
        echo "option"
        echo " help      このヘルプを表示"
        echo " install   シンボリックリンクを設置"
        echo " clean     シンボリックリンクを削除"
    elif [ ${1} == "install" ]
    then
        echo -e ${HOME_DOTFILES}|\
            while read TMP
            do
                ln -s ${PWD}/${TMP} ~/${TMP}
                echo "install ~/${TMP}"
            done
    elif [ ${1} == "clean" ]
    then
            echo -e ${HOME_DOTFILES}|\
                while read TMP
                do
                    rm -r ~/${TMP}
                    echo "clean ~/${TMP}"
                done
    else
        echo "unknown option argument: ${1}"
    fi
fi
