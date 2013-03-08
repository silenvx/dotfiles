#!/bin/sh
cd "$(dirname ${0})"
# 設定用変数{{{
# 出力先のファイルを置く場所を書く
status_cpu_tmp_file='/tmp/tmux_tmp_cpu'
# 数値に使われる色などをtmux形式で書く
tmux_color='#[fg=red,underscore]'
# 数値の後ろに使われる色などをtmux形式で書く
tmux_color_default="${tmux_color:+#[default]}"
# /proc/statの1行目の前から順に名前を書く(cpuは含まない)
status_cpu_kind='us ni sy id wa hi si st'
# 表示したい順序に先ほど書いた名前を書く(書かなければ非表示)
status_cpu_view='us sy ni wa id'
# 情報を取得する間隔
status_cpu_sleep_time='1'
# }}}設定用変数
# 多重起動チェック{{{
if [ "${$}" != `pgrep -xfo "/bin/sh ${0}"` ];then
    if [ -f "${status_cpu_tmp_file}" ];then
        cat "${status_cpu_tmp_file}"
    fi
    exit 1
fi
# }}}多重起動チェック
# 出力先にディレクトリがなければ強制的に作成する{{{
    if [ ! -d "${status_cpu_tmp_file%/*}" ];then
        rm -f "${status_cpu_tmp_file%/*}"
        mkdir -p "${status_cpu_tmp_file%/*}"
    fi
# }}}出力先にディレクトリがなければ強制的に作成する
## 出力先を名前付きパイプにする(不具合が出るのでアイディアが出るまで無効){{{
#if [ -z "`find \"${status_cpu_tmp_file}\" -type p`" ];then
#    rm -f "${status_cpu_tmp_file}"
#    mknod "${status_cpu_tmp_file}" p
#fi
## }}}出力先を名前付きパイプにする
# 初期化とtmuxが生きているか判定。死んでいればこのスクリプトも終了する{{{
printf "start ${tmux_color}${0##*/}${tmux_color_default}\n"|tee "${status_cpu_tmp_file}"
status_cpu_tmux_pid=`echo "${TMUX}"|cut -d ',' -f2`
status_cpu_starttime=`cut -d ' ' -f22 "/proc/${$}/stat"`
IFS=' '
status_cpu_new=`head -1 '/proc/stat'|sed 's/  */ /g'`
while [ \( -e "/proc/${status_cpu_tmux_pid}" \) -a \( "${status_cpu_starttime}" -ge `cut -d ' ' -f22 "/proc/${status_cpu_tmux_pid}/stat"` \) ];do
    # }}}初期化とtmuxが生きているか判定。死んでいればこのスクリプトも終了する
    # 情報取得{{{
    status_cpu_output=''
    status_cpu_old="${status_cpu_new}"
    sleep "${status_cpu_sleep_time}"
    status_cpu_new=`head -1 '/proc/stat'|sed 's/  */ /g'`
    # }}}情報取得
    # 過去の累計CPU使用量を別ける{{{
    i=2
    for TMP in ${status_cpu_kind} ;do
        eval status_cpu_old_${TMP}=`echo "${status_cpu_old}"|cut -d ' ' -f "${i}"`
        i=`expr "${i}" + 1`
    done
    # }}}過去の累計CPU使用量を別ける
    # 現在の累計CPU使用量を別ける{{{
    i=2
    for TMP in ${status_cpu_kind} ;do
        eval status_cpu_new_${TMP}=`echo "${status_cpu_new}"|cut -d ' ' -f "${i}"`
        i=`expr "${i}" + 1`
    done
    # }}}現在の累計CPU使用量を別ける
    # CPU使用量の変動値を求める{{{
    for TMP in ${status_cpu_kind} ;do
        eval status_cpu_sub_${TMP}=`eval expr \"\$\{status_cpu_old_${TMP}\}\" - \"\$\{status_cpu_new_${TMP}\}\"`
    done
    # }}}CPU使用量の変動値を求める
    # 全体のCPU使用率を求める{{{
    status_cpu_total=0
    for TMP in ${status_cpu_kind} ;do
        status_cpu_total=`eval expr "${status_cpu_total}" + \"\$\{status_cpu_sub_${TMP}\}\"`
    done
    # }}}全体のCPU使用率を求める
    # CPU使用率を求める{{{
    for TMP in ${status_cpu_kind} ;do
        eval status_cpu_per_${TMP}=`eval echo \"scale=2\;\$\{status_cpu_sub_${TMP}\} / ${status_cpu_total}\"|bc`
    done
    # }}}CPU使用率を求める
    # 結果の表示{{{
    for TMP in ${status_cpu_view};do
        status_cpu_output="${status_cpu_output}$(eval printf \"${tmux_color}%01.2f${tmux_color_default} ${TMP}, \" \"\$\{status_cpu_per_${TMP}\}\")"
    done
    ## 誰も読み込まないならパイプをkillする(不具合が出るのでアイディアが出るまで無効){{{
    #    if [ \( -n "${status_cpu_fifo_pid}" \) -a \( -e "/proc/${status_cpu_fifo_pid}" \) -a \( "${status_cpu_fifo_starttime}" == `cut -d ' ' -f22 "/proc/${status_cpu_fifo_pid}/stat" 2>/dev/null` \) ] 2>/dev/null;then
    #        kill -TERM ${!}
    #    fi
    ## }}}誰も読み込まないならパイプをkillする
    ## killする情報の取得(不具合が出るのでアイディアが出るまで無効){{{
    #    status_cpu_fifo_pid=${!}
    #    status_cpu_starttime=`cut -d ' ' -f22 "/proc/${status_cpu_fifo_pid}/stat" 2>/dev/null`
    ## }}}killする情報の取得
    printf "${status_cpu_output%%, }\n" > "${status_cpu_tmp_file}"
    # }}}結果の表示
done

# vim:set fdm=marker:
