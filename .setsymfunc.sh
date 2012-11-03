# 関数の種類{{{

# .setsymlistに書くのに必要な 識別名 必要な引数の数 というように書きます
SYM_FUNCLIST='default 2
firefox 2'
# }}}関数の種類
# setsym.shに呼び出される関数{{{

# ${SYM_FUNCLIST}に書いた識別名の処理を書きます
# -iの時にはfunc_install_識別名
# -rの時にはfunc_remove_識別名
# -tの時にはfunc_test_識別名
# -sの時にはfunc_search_識別名
# が呼び出されます
#
# -fは${FLAG_f}でtrueもしくはNULLになっていて有効だと1文字以上の文字があります
# -vは${FLAG_v}でtrueもしくはNULLになっていて有効だと1文字以上の文字があります
# -fや-vの処理や関数は各自で作成してください
func_force_clean(){ #{{{
    if [ -d "${2}" -a -e "${2}/${1##*/}" ];then
        if [ -n "${FLAG_v}" ];then
            echo rm -rf "${2}/${1##*/}"
        fi
        rm -rf "${2}/${1##*/}"
        return 0
    else
        if [ -f "${2}" ];then
            if [ -n "${FLAG_v}" ];then
                echo rm -rf "${2}"
            fi
            rm -rf "${2}"
            return 0
        else
            ls -ad "${2}/${1##*/}" >/dev/null 2>&1
            if [ "${?}" == "0" ];then
                if [ ! -e `realpath -m "${2}/${1}"` ];then
                    if [ -n "${FLAG_v}" ];then
                        echo rm -rf "${2}/${1##*/}"
                    fi
                    rm -rf "${2}/${1##*/}"
                    return 0
                fi
            fi
            ls -ad "${2}" >/dev/null 2>&1
            if [ "${?}" == "0" ];then
                if [ ! -e `realpath -m "${2}"` ];then
                    if [ -n "${FLAG_v}" ];then
                        echo rm -rf "${2}"
                    fi
                    rm -rf "${2}"
                    return 1
                fi
            fi
        fi
    fi
} #}}}
# default{{{

# .setsymlistの default <source> <dest>が
# ln -s <source> <dest>の処理をします
# 外部からこの関数を使うなら
# func_install_default <source> <dest>と大体同じです
# -fで既にファイルがあった場合それを消してln -sをする
func_install_default(){ #{{{
    LN_SOURCE="$(eval eval realpath -ms ${1})"
    LN_DEST="$(eval eval realpath -ms ${2})"
    if [ -n "${FLAG_f}" ];then
        func_force_clean "${LN_SOURCE}" "${LN_DEST}"
    fi
    if [ -e "${LN_SOURCE}" ];then
        if [ -d "${LN_DEST}" -a -e "${LN_DEST}/${LN_SOURCE##*/}" ];then
            if [ -n "${FLAG_v}" ];then
                echo "既に${LN_DEST}/${LN_SOURCE##*/}がありました" >&2
            fi
            return 1
        else
            if [ -f "${LN_DEST}" ];then
                if [ -n "${FLAG_v}" ];then
                    echo "既に${LN_DEST}がありました" >&2
                fi
                return 1
            else
                if [ -n "${FLAG_f}" -a ! -d "${LN_DEST%/*}" ];then
                    if [ -n "${FLAG_v}" ];then
                        echo mkdir -p "${LN_DEST%/*}"
                    fi
                    mkdir -p "${LN_DEST%/*}"
                fi
                ls -ad "${LN_DEST}/${LN_SOURCE##*/}" >/dev/null 2>&1
                if [ "${?}" == "0" ];then
                    if [ ! -e `realpath -m "${LN_DEST}/${LN_SOURCE}"` ];then
                        if [ -n "${FLAG_v}" ];then
                            echo "既に${LN_DEST}/${LN_SOURCE##*/}がありましたがシンボリックの先がない可能性があります" >&2
                        fi
                        return 1
                    fi
                fi
                ls -ad "${LN_DEST}" >/dev/null 2>&1
                if [ "${?}" == "0" ];then
                    if [ ! -e `realpath -m "${LN_DEST}"` ];then
                        if [ -n "${FLAG_v}" ];then
                            echo "既に${LN_DEST}がありましたがシンボリックの先がない可能性があります" >&2
                        fi
                        return 1
                    fi
                fi
                if [ -n "${FLAG_v}" ];then
                    echo ln -s "${LN_SOURCE}" "${LN_DEST}"
                fi
                ln -s "${LN_SOURCE}" "${LN_DEST}"
            fi
        fi
    else
        if [ -n "${FLAG_v}" ];then
            echo "${LN_SOURCE}がありません" >&2
        fi
        return 1
    fi
} #}}}
func_remove_default(){ #{{{
    LN_SOURCE="$(eval eval realpath -ms ${1})"
    LN_DEST="$(eval eval realpath -ms ${2})"
    if [ -n "${FLAG_f}" ];then
        func_force_clean "${LN_SOURCE}" "${LN_DEST}"
        return 0
    fi
    if [ -e "${LN_SOURCE}" ];then
        if [ -d "${LN_DEST}" -a -e "${LN_DEST}/${LN_SOURCE##*/}" ];then
            if [ "${LN_SOURCE}" == `realpath -m "${LN_DEST}/${LN_SOURCE##*/}"` ];then
                if [ -n "${FLAG_v}" ];then
                    echo rm "${LN_DEST}/${LN_SOURCE##*/}"
                fi
                rm "${LN_DEST}/${LN_SOURCE##*/}"
                return 0
            else
                if [ -n "${FLAG_v}" ];then
                    echo "${LN_DEST}/${LN_SOURCE##*/}は現在のスクリプトなどで貼ったものではありません" >&2
                fi
                return 1
            fi
        else
            if [ -f "${LN_DEST}" ];then
                if [ "${LN_SOURCE}" == `realpath -m "${LN_DEST}"` ];then
                    if [ -n "${FLAG_v}" ];then
                        echo rm "${LN_DEST}"
                    fi
                    rm "${LN_DEST}"
                    return 0
                else
                    if [ -n "${FLAG_v}" ];then
                        echo "${LN_DEST}は現在のスクリプトなどで貼ったものではありません" >&2
                    fi
                    return 1
                fi
            else
                ls -ad "${LN_DEST}/${LN_SOURCE##*/}" >/dev/null 2>&1
                if [ "${?}" == "0" ];then
                    if [ ! -e `realpath -m "${LN_DEST}/${LN_SOURCE}"` ];then
                        if [ -n "${FLAG_v}" ];then
                            echo "${LN_DEST}は現在のスクリプトなどで貼ったものではありませんがシンボリックの先がない可能性があります" >&2
                        fi
                        return 1
                    fi
                fi
                ls -ad "${LN_DEST}" >/dev/null 2>&1
                if [ "${?}" == "0" ];then
                    if [ ! -e `realpath -m "${LN_DEST}"` ];then
                        if [ -n "${FLAG_v}" ];then
                            echo "${LN_DEST}は現在のスクリプトなどで貼ったものではありませんがシンボリックの先がない可能性があります" >&2
                        fi
                        return 1
                    fi
                fi
            fi
        fi
    else
        if [ -n "${FLAG_v}" ];then
            echo "${LN_SOURCE}がありません" >&2
        fi
        return 1
    fi
} #}}}
func_test_default(){ #{{{
    if [ -n "${FLAG_v}" ];then
        printf "1:${1}\n2:${2}\n\n"
    fi
} #}}}
func_search_default(){ #{{{
# TODO:エスケープを1つ外すためにevalを使っている
    for j in `eval find "${SYM_DOTFILES}/default" -maxdepth 2 -mindepth 2`;do
        printf "default \"${j}\" \"`echo "${j}"|sed -e "s/^${SYM_DOTFILES}\/default\//\$\{/" -e 's/\/.*/}\//'`\"\n"
    done
} #}}}
# }}}default
# firefox{{{

# .setsymlistの firefox <source> <dest>
# ln -s <source> <firefoxのprofile>/<dest>の処理をします
# firefoxのprofileは${FIREFOX_PROFILES_INI}の変数のファイルを見て決めます
# 複数プロファイルがあった場合はメニューを表示して入力待ちをします
# func_firefox_profileがそういうプロファイルの場所を決める関数です
FIREFOX_PROFILES_INI=`realpath ~/.mozilla/firefox/profiles.ini`
func_firefox_profile(){ #{{{
    if [ -f "${FIREFOX_PROFILES_INI}" ];then
        i=0
        IFS=$'\n'
        for TMP in `grep "^Path=" "${FIREFOX_PROFILES_INI}"`;do
            i=`expr ${i} + 1`
            eval FIREFOX_PROFILE_PATH${i}=`cd ${FIREFOX_PROFILES_INI%/*};realpath "${TMP#Path=}"`
        done
        if [ "${i}" == "0" ];then
            echo "${FIREFOX_PROFILES_INI}にプロファイルディレクトリの記載がありませんでした" >&2
            return 1
        elif [ "${i}" == "1" ];then
            k="1"
        elif [ "${i}" -ge "2" ];then
            echo "番号でfirefoxのprofileのパスを指定してください" >&2
            for j in `seq 1 ${i}`;do
                eval echo \"${j}:\${FIREFOX_PROFILE_PATH${j}}\" >&2
            done
            echo -n " > " >&2
            read k
            while [ ! \( "${k}" -ge "1" -a "${k}" -le "${i}" \) ];do
                echo -n "1から${i}の間を入力してください > " >&2
                read k
            done
        else
            echo "予期せぬエラーが発生しました" >&2
            return 1
        fi
        FIREFOX_PROFILE_PATH=$(eval echo "\${FIREFOX_PROFILE_PATH${k}}")
        if [ ! -d "${FIREFOX_PROFILE_PATH}" ];then
            echo "firefoxのプロファイルディレクトリ${FIREFOX_PROFILE_PATH}がないです" >&2
            return 1
        fi
        echo "${FIREFOX_PROFILE_PATH}"
        return 0
    else
        echo "${FIREFOX_PROFILES_INI}が見つかりませんでした" >&2
        return 1
    fi
} #}}}
func_install_firefox(){ #{{{
    FIREFOX_PROFILE_PATH=`func_firefox_profile`
    if [ "${?}" == "1" ];then
        return 1
    fi
    func_install_default "${1}" "${FIREFOX_PROFILE_PATH}/${2}"
} #}}}
func_remove_firefox(){ #{{{
    FIREFOX_PROFILE_PATH=`func_firefox_profile`
    if [ "${?}" == "1" ];then
        return 1
    fi
    func_remove_default "${1}" "${FIREFOX_PROFILE_PATH}/${2}"
} #}}}
func_test_firefox(){ #{{{
    if [ -n "${FLAG_v}" ];then
        printf "1:${1}\n2:${2}\n\n"
    fi
} #}}}
func_search_firefox(){ #{{{
# TODO:エスケープを1つ外すためにevalを使っている
    for j in `eval find "${SYM_DOTFILES}/firefox/" -maxdepth 1 -mindepth 1`;do
        printf "firefox \"${j}\" \"./\"\n"
    done
} #}}}
# }}}firefox
# その他特殊な関数{{{
# }}}その他特殊な関数
# }}}setsym.shに呼び出される関数

# vim: set fdm=marker:
