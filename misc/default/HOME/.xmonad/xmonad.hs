import XMonad

-- default terminal
myTerminal = "xterm"

-- prefix key wo window key
myModMask = mod4Mask

main = xmonad $ defaultConfig{
    terminal = myTerminal,
    modMask = myModMask
}
