import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.ToggleLayouts
import XMonad.Util.EZConfig (additionalKeys, removeKeys)
import XMonad.Util.Run (spawnPipe)

myModMask  = mod4Mask
myTerminal = "gnome-terminal"
myFileBrowser = "nautilus"

myLayout = Tall 1 (3/100) (1/2) ||| Grid ||| Full

myKeybindings = [ ((myModMask .|. shiftMask, xK_q), kill)
                , ((myModMask .|. shiftMask, xK_f), spawn myFileBrowser)

                , ((myModMask, xK_p), spawn "dmenu_run -fn \"Iosevka Term-11\"")

                , ((myModMask, xK_Print), spawn "scrot")

                -- Mute sound (toggle)
                , ((myModMask, xK_F1), spawn "pactl set-sink-mute alsa_output.pci-0000_00_1b.0.analog-stereo toggle")
                -- Volume up
                , ((myModMask, xK_F2), spawn "pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo -5%")
                -- Volume down
                , ((myModMask, xK_F3), spawn "pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo +5%") ]

myUnbindKeys = [ (myModMask .|. shiftMask, xK_q) ]

main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/.xmobarrc"
  xmonad $ def
    { manageHook         = manageDocks <+> manageHook defaultConfig
    , layoutHook         = smartBorders $ avoidStruts $ myLayout
    , logHook            = dynamicLogWithPP xmobarPP { ppOutput  = hPutStrLn xmproc
                                                     , ppTitle   = \_ -> ""
                                                     , ppCurrent = xmobarColor "#4682B4" ""
                                                     , ppSep     = " | "
                                                     }
    , handleEventHook    = handleEventHook defaultConfig <+> docksEventHook
    , borderWidth        = 2
    , normalBorderColor  = "#000000"
    , focusedBorderColor = "#cd8b00"
    , modMask            = myModMask }
    `removeKeys` myUnbindKeys
    `additionalKeys` myKeybindings
