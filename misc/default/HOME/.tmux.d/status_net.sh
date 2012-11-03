#!/bin/sh
cd "$(dirname ${0})"
# 設定用変数{{{
# 出力先のファイルを置く場所を書く
status_net_tmp_file='./tmp/tmp_net'
# 数値に使われる色などをtmux形式で書く
tmux_color='#[fg=cyan,underscore]'
# 数値の後ろに使われる色などをtmux形式で書く
tmux_color_default="${tmux_color:+#[default]}"
# 観測するインターフェイス名
status_net_interface='wlan0'
# 表示するのに使う単位を書く(左から2^10,2^20と累乗が10ずつ増えていく計算式になっています)
status_net_unit='KiB MiB GiB TiB PiB EiB ZiB YiB'
# 数値の長さを書く。小数点含む
status_net_length='4'
# 情報を取得する間隔
status_net_sleep_time='1'
# }}}設定用変数
# 多重起動チェック{{{
if [ "${$}" != `pgrep -xfo "/bin/sh ${0}"` ];then
    if [ -f "${status_net_tmp_file}" ];then
        cat "${status_net_tmp_file}"
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
# 初期化とtmuxが生きているか判定。死んでいればこのスクリプトも終了する{{{
printf "start ${tmux_color}${0##*/}${tmux_color_default}\n" >"${status_net_tmp_file}"
status_net_floor=''
i=0
j=0
IFS=' '
for TMP in `sed -n 2p /proc/net/dev|sed -e 's/|/ /g' -e 's/  */ /g' -e 's/^ *//g'`;do
    i=`expr "${i}" + 1`
    echo "${TMP}"|grep 'bytes' > /dev/null 2>&1
    if [ "${?}" != '0' ];then
        continue
    elif [ "${j}" -ge '2' ];then
        echo 'incompatible'
        exit 1
    fi
    status_net_floor="${status_net_floor} ${i}"
    j=`expr "${j}" + 1`
done
status_net_tmux_pid=`cut -d ' ' -f4 "/proc/${$}/stat"`
status_net_starttime=`cut -d ' ' -f22 "/proc/${$}/stat"`
status_net_time_new_0=`cat /proc/uptime`
status_net_new=`cat /proc/net/dev`
status_net_time_new_1=`cat /proc/uptime`
while [ \( -e "/proc/${status_net_tmux_pid}" \) -a \( "${status_net_starttime}" -ge `cut -d ' ' -f22 "/proc/${status_net_tmux_pid}/stat"` \) ];do
    status_net_unit_0='b  '
    status_net_unit_1='b  '
    status_net_per_0='1'
    status_net_per_1='1'
    # }}}初期化とtmuxが生きているか判定。死んでいればこのスクリプトも終了する
    # 情報取得{{{
    status_net_time_old_0="${status_net_time_new_0}"
    status_net_old="${status_net_new}"
    status_net_time_old_1="${status_net_time_new_1}"
    sleep "${status_net_sleep_time}"
    status_net_time_new_0=`cat /proc/uptime`
    status_net_new=`cat /proc/net/dev`
    status_net_time_new_1=`cat /proc/uptime`

    status_net_old=`echo "${status_net_old}"|grep "^ *${status_net_interface}:"|sed -e 's/  */ /g' -e 's/^ *//g'`
    status_net_new=`echo "${status_net_new}"|grep "^ *${status_net_interface}:"|sed -e 's/  */ /g' -e 's/^ *//g'`
    if [ -z "${status_net_old}" -o -z "${status_net_new}" ];then
        echo "not found ${status_net_interface}"
        exit 1
    fi
    # }}}情報取得
    # 送信と受信を別ける{{{
    i=0
    for TMP in ${status_net_floor};do
        eval status_net_old_bytes_${i}=`echo "${status_net_old}"|cut -d ' ' -f "${TMP}"`
        eval status_net_new_bytes_${i}=`echo "${status_net_new}"|cut -d ' ' -f "${TMP}"`
        i=`expr "${i}" + 1`
    done
    # }}}送信と受信を別ける
    # 秒速を計算{{{
    status_net_time_old=`echo "(${status_net_time_old_0%% *}+${status_net_time_old_1%% *})/2"|bc`
    status_net_time_new=`echo "(${status_net_time_new_0%% *}+${status_net_time_new_1%% *})/2"|bc`
    status_net_time=`echo "(${status_net_time_new%% *}-${status_net_time_old%% *})"|bc`
    status_net_speed_0=`echo "scale=${status_net_length};(${status_net_new_bytes_0}-${status_net_old_bytes_0})/${status_net_time}"|bc`
    status_net_speed_1=`echo "scale=${status_net_length};(${status_net_new_bytes_1}-${status_net_old_bytes_1})/${status_net_time}"|bc`
    # }}}秒速を計算
    # 単位を計算{{{
    for i in 0 1;do
        j=1
        for TMP in ${status_net_unit};do
            status_net_per=`echo "2^${j}0"|bc`
            k=`eval echo \"\$\{status_net_speed_${i}\} \< ${status_net_per}\"|bc`
            if [ "${k}" == '1' ];then
                continue 2
            fi
            eval status_net_unit_${i}=\"\$\{TMP\}\"
            eval status_net_per_${i}=\"\$\{status_net_per\}\"
            j=`expr "${j}" + 1`
        done
    done
    # }}}単位を計算
    # 桁数の調整{{{
    for i in 0 1;do
        eval status_net_speed_${i}=\"`eval echo \"scale=${status_net_length}\;\$\{status_net_speed_${i}\}/\$\{status_net_per_${i}\}\"|bc|sed -e 's/^\./0./'|cut -c1-4|sed -e 's/\.$//g'`\"
    done
    # }}}桁数の調整
    # 結果の表示{{{
    printf "${tmux_color}%${status_net_length}s${tmux_color_default} ${status_net_unit_0}/s down, ${tmux_color}%${status_net_length}s${tmux_color_default} ${status_net_unit_1}/s up\n" "${status_net_speed_0}" "${status_net_speed_1}" > "${status_net_tmp_file}"
    # }}}結果の表示
done

## vim:set fdm=marker:
