#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/Xresources
sysmodmap=/etc/X11/xinit/Xmodmap

setxkbmap -layout jp -model jp106

export LANG="en_US.UTF-8"

# ibus
#export GTK_IM_MODULE="xim"
#export QT_IM_MODULE="xim"
#export XMODIFIERS="@im=ibus"
#ibus-daemon -d -x

# uim on gentoo
#export GTK_IM_MODULE="xim"
#export QT_IM_MODULE="xim"
#export XMODIFIERS="@im=uim"
#export UIM_CANDWIN_PROG="uim-candwin-qt4"
#exec uim-xim &
#exec uim-toolbar-qt4 &

# uim on archlinux
export GTK_IM_MODULE="uim"
export QT_IM_MODULE="uim"
export XMODIFIERS="@im=uim"
export UIM_CANDWIN_PROG="uim-candwin-qt4"
exec uim-xim &
#exec uim-toolbar-qt4 &

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -n "`/etc/X11/chooser.sh`" ]; then
    command="`/etc/X11/chooser.sh`"
else
    failsafe="yes"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/* ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

if [ -n "$failsafe" ]; then
    #xcompmgr &
    exec awesome
else
    exec $command
fi

