#!/bin/sh
cd "$(dirname ${0})"
# 設定用変数{{{
# 出力先のファイルを置く場所を書く
status_mem_tmp_file='/tmp/tmux_tmp_mem'
# 数値に使われる色などをtmux形式で書く
tmux_color='#[fg=blue,underscore]'
# 数値の後ろに使われる色などをtmux形式で書く
tmux_color_default="${tmux_color:+#[default]}"
# }}}設定用変数
# 多重起動チェック{{{
if [ "${$}" != `pgrep -xfo "/bin/sh ${0}"` ];then
    if [ -f "${status_mem_tmp_file}" ];then
        cat "${status_mem_tmp_file}"
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
# 初期化とtmuxが生きているか判定。死んでいればこのスクリプトを終了する{{{
printf "start ${tmux_color}${0##*/}${tmux_color_default}\n" > "${status_mem_tmp_file}"
status_mem_tmux_pid=`cut -d ' ' -f4 "/proc/${$}/stat"`
status_mem_starttime=`cut -d ' ' -f22 "/proc/${$}/stat"`
IFS=$'\n'
while [ \( -e "/proc/${status_mem_tmux_pid}" \) -a \( "${status_mem_starttime}" -ge `cut -d ' ' -f22 "/proc/${status_mem_tmux_pid}/stat"` \) ];do
    # }}}初期化とtmuxが生きているか判定。死んでいればこのスクリプトを終了する
    # 情報を抜き出したり計算して結果を出力する{{{
    for TMP in `cat /proc/meminfo|egrep '^(MemTotal|MemFree|SwapTotal|SwapFree):'|sed -e 's/  */ /g' -e 's/ kB$//g'`;do
        eval status_mem_${TMP%%:*}=${TMP##* }
    done
    printf "${tmux_color}%01.2f${tmux_color_default} Mem, ${tmux_color}%01.2f${tmux_color_default} Swap\n" `echo "scale=2;1 - ${status_mem_MemFree} / ${status_mem_MemTotal}"|bc` `echo "scale=2;1 - ${status_mem_SwapFree} / ${status_mem_SwapTotal}"|bc` > "${status_mem_tmp_file}"
    # }}}情報を抜き出したり計算して結果を出力する
done

# vim:set foldmethod=marker:
