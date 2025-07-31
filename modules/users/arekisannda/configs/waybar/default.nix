{ config, lib, pkgs, ... }:
# waybar modules 
# modules:
#   wireplumber: &wireplumber
#     scroll-step: 5.0
#     max-volume: 100.0
#     format: '{icon} {volume}'
#     format-muted: 󰖁
#     format-source: ""
#     format-source-muted: 󰍭
#     format-icons:
#       - 󰕿
#       - 󰖀
#       - 󰕾
#     tooltip-format: '{node_name}'
#     on-click: pavucontrol
#     on-click-right: qjackctl
#     on-click-middle: swaymsg exec "\$volume_mute" && pkill -RTMIN+3 waybar
#     on-scroll-up: swaymsg exec "\$volume_up" && pkill -RTMIN+3 waybar
#     on-scroll-down: swaymsg exec "\$volume_down" && pkill -RTMIN+3 waybar
#     signal: 3
  
#   sway/workspaces: &sway-workspaces
#     disable-scroll: false 
#     format: '{name}'
#     format-icons:
#       "1": 
#       "2": 
#       "3": 
#       "4": 
#       "5": 
#       urgent: 
#       focused: 
#       default: 
#     window-rewrite-default: '{name}'
#     window-format: <span color='#e0e0e0'>{name}</span>
#     window-rewrite:
#       .*: 
#     on-update: pkill -RTMIN+7 waybar
#     signal: 7
  
#   sway/window: &sway-window
#     min-length: 20
#     max-length: 100
#     on-click: swaymsg exec "\$sway_windows"
  
#   custom/pacman: &custom-pacman
#     format: 󰀼
#     interval: 3600
#     exec: (pacman -Qu && yay -Qua) | wc -l
#     on-click: pkill -RTMIN+4 waybar
#     signal: 4
  
#   custom/github: &custom-github
#     interval: 300
#     tooltip: false
#     return-type: json
#     format: ' {}'
#     exec: 'gh api "/notifications" -q "{ text: length }" | cat -'
#     exec-if: '[ -x "$(command -v gh)" ] && gh auth status 2>&1 | grep -q -m 1 "Logged in" && gh api "/notifications" -q "length" | grep -q -m 1 "0" ; test $? -eq 1'
#     on-click: xdg-open https://github.com/notifications && sleep 30 && pkill -RTMIN+5 waybar
#     signal: 5
  
#   custom/vpn: &custom-vpn
#     interval: 5
#     tooltip: true
#     return-type: json
#     exec: /bin/sh $HOME/.config/sway/scripts/vpn.sh
#     format: '{icon}'
#     format-icons:
#       secure: 󰯄
#       insecure: 󰒙
#     signal: 11
  
#   custom/wf-recorder: &custom-wf-recorder
#     interval: once
#     return-type: json
#     format: '{}'
#     tooltip: true
#     exec: /bin/sh $HOME/.config/sway/scripts/recorder-status.sh
#     on-click: killall -s SIGINT wf-recorder
#     signal: 8
  
#   custom/focus-follows-mouse: &custom-focus-follows-mouse
#     interval: 5
#     tooltip: true
#     return-type: json
#     exec: /bin/sh $HOME/.config/sway/scripts/focus-follows-mouse.sh status
#     format: '{icon}'
#     format-icons:
#       on: 󰍽
#       off: 󰍽
#     on-click: /bin/sh $HOME/.config/sway/scripts/focus-follows-mouse.sh toggle && pkill -RTMIN+13 waybar
#     signal: 13
  
#   custom/builtin-keyboard-stealth: &custom-builtin-keyboard-stealth
#     interval: 5
#     tooltip: true
#     return-type: json
#     exec: /bin/sh $HOME/.config/sway/scripts/toggle-keyboard.sh 5426:594:Razer_Razer_Blade_Keyboard status
#     exec-if: '[ -n "$(swaymsg -t get_inputs | grep 5426:594:Razer_Razer_Blade_Keyboard)" ]'
#     format: '{icon}'
#     format-icons:
#       enabled: 󰌌
#       disabled: 󰌐
#     on-click: /bin/sh $HOME/.config/sway/scripts/toggle-keyboard.sh 5426:594:Razer_Razer_Blade_Keyboard toggle && pkill -RTMIN+14 waybar
#     signal: 14
  
#   custom/bluetooth-device-airloop: &custom-bluetooth-device-airloop
#     interval: 5
#     tooltip: true
#     return-type: json
#     exec: /bin/sh $HOME/.config/sway/scripts/bluetooth-device.sh 'AirLoop' status
#     exec-if: /bin/sh $HOME/.config/sway/scripts/bluetooth-device.sh 'AirLoop' paired
#     format: '{icon}'
#     format-icons:
#       connected: 󰋎
#       disconnected: 󰋐
#     on-click: /bin/sh $HOME/.config/sway/scripts/bluetooth-device.sh 'AirLoop' toggle && pkill -RTMIN+15 waybar
#     signal: 15
  
#   custom/bluetooth-device-sony: &custom-bluetooth-device-sony
#     interval: 5
#     tooltip: true
#     return-type: json
#     exec: /bin/sh $HOME/.config/sway/scripts/bluetooth-device.sh 'WF-1000XM5' status
#     exec-if: /bin/sh $HOME/.config/sway/scripts/bluetooth-device.sh 'WF-1000XM5' paired
#     format: '{icon}'
#     format-icons:
#       connected: 󰋎
#       disconnected: 󰋐
#     on-click: /bin/sh $HOME/.config/sway/scripts/bluetooth-device.sh 'WF-1000XM5' toggle && pkill -RTMIN+15 waybar
#     signal: 15
  
#   custom/mode-clock: &custom-mode-clock
#     interval: 10
#     return-type: json
#     format: '{}'
#     tooltip: true
#     exec: /bin/sh $HOME/.config/sway/scripts/waybar-mode-clock.sh
#     signal: 16
  
#   custom/scratchpad: &custom-scratchpad
#     interval: once
#     return-type: json
#     format: '{icon}'
#     format-icons:
#       one: 󰖯
#       many: 󰖲
#     exec: /bin/sh $HOME/.config/sway/scripts/scratchpad.sh
#     on-click: swaymsg 'scratchpad show'
#     signal: 7
  
#   idle_inhibitor: &idle-inhibitor
#     format: '{icon}'
#     format-icons:
#       activated: 󰅶
#       deactivated: 󰛊
#     tooltip: true
#     tooltip-format-activated: power-saving disabled
#     tooltip-format-deactivated: power-saving enabled
#     timeout: 360
  
#   pulseaudio: &pulseaudio
#     scroll-step: 5
#     format: '{icon} {volume}'
#     format-muted: 󰖁
#     format-source: ""
#     format-source-muted: 󰍭
#     format-icons:
#       default:
#         - 󰕿
#         - 󰖀
#         - 󰕾
#     tooltip-format: '{format_source} {desc}'
#     on-click: pavucontrol
#     on-click-right: qjackctl
#     on-click-middle: swaymsg exec "\$volume_mute" && pkill -RTMIN+3 waybar
#     on-scroll-up: swaymsg exec "\$volume_up" && pkill -RTMIN+3 waybar
#     on-scroll-down: swaymsg exec "\$volume_down" && pkill -RTMIN+3 waybar
#     signal: 3
  
#   custom/notification: &custom-notification
#     tooltip: true
#     format: '{icon}'
#     format-icons:
#       notification: 󰂚
#       none: 󰂜
#       dnd-notification: 󱅫
#       dnd-none: 󰅸
#       inhibited-notification: 󰂚
#       inhibited-none: 󰂜
#       dnd-inhibited-notification: 󱅫
#       dnd-inhibited-none: 󰅸
#     return-type: json
#     exec: swaync-client -swb
#     on-click: swaync-client -t -sw
#     on-click-right: swaync-client -C
#     on-click-middle: swaync-client -d -sw
#     escape: true
  
#   custom/sunset: &custom-sunset
#     interval: once
#     tooltip: true
#     return-type: json
#     format: '{icon}'
#     format-icons:
#       on: 󰌵
#       off: 󰌶
#     exec: latitude=38 longitude=-122 $HOME/.config/sway/scripts/sunset.sh
#     on-click: $HOME/.config/sway/scripts/sunset.sh toggle; pkill -RTMIN+6 waybar
#     exec-if: $HOME/.config/sway/scripts/sunset.sh check
#     signal: 6
  
#   custom/adaptive-light: &custom-adaptive-light
#     interval: once
#     tooltip: true
#     return-type: json
#     format: '{icon}'
#     format-icons:
#       on: 󰃡
#       off: 󰃠
#     exec: $HOME/.config/sway/scripts/wluma.sh
#     on-click: $HOME/.config/sway/scripts/wluma.sh toggle; pkill -RTMIN+12 waybar
#     exec-if: $HOME/.config/sway/scripts/wluma.sh check
#     signal: 12
  
#   battery: &battery
#     interval: 30
#     states:
#       warning: 30
#       critical: 15
#     format-charging: '󰂄 {capacity}'
#     format: '{icon} {capacity}'
#     format-icons:
#       - 󱃍
#       - 󰁺
#       - 󰁼
#       - 󰁽
#       - 󰁾
#       - 󰁿
#       - 󰂀
#       - 󰂁
#       - 󰂂
#       - 󰁹
#     tooltip: true
  
#   backlight: &backlight
#     format: '{icon} {percent}%'
#     format-icons:
#       - 󰃞
#       - 󰃟
#       - 󰃠
#     on-scroll-up: swaymsg exec "\$brightness_up"
#     on-scroll-down: swaymsg exec "\$brightness_down"
  
#   tray: &tray
#     icon-size: 14
#     spacing: 12
  
#   privacy: &privacy
#     icon-spacing: 6
#     icon-size: 12
#     transition-duration: 250
#     modules:
#       - type: screenshare
#         tooltip: true
#         tooltip-icon-size: 12
#       - type: audio-out
#         tooltip: true
#         tooltip-icon-size: 12
#       - type: audio-in
#         tooltip: true
#         tooltip-icon-size: 12
  
#   cpu: &cpu
#     interval: 10
#     format: 󰘚
#     states:
#       warning: 70
#       critical: 90
#     on-click: swaymsg exec "\$once \$term_float -e htop"
#     tooltip: true
  
#   memory: &memory
#     interval: 10
#     format: 󰍛
#     states:
#       warning: 70
#       critical: 90
#     on-click: swaymsg exec "\$once \$term_float -e htop"
#     tooltip: true
  
#   network: &network
#     interval: 5
#     format-wifi: 󰖩
#     format-ethernet: 󰈀
#     format-disconnected: 󰖪
#     tooltip-format: '{icon} {ifname}: {ipaddr}'
#     tooltip-format-ethernet: '{icon} {ifname}: {ipaddr}'
#     tooltip-format-wifi: '{icon} {ifname} ({essid}): {ipaddr}'
#     tooltip-format-disconnected: '{icon} disconnected'
#     tooltip-format-disabled: '{icon} disabled'
#     on-click: swaymsg exec "\$once \$term_float -e watch -n 1 -p ifstat"
  
#   temperature: &temperature-1
#     critical-threshold: 90
#     hwmon-path:
#       - /sys/class/hwmon/hwmon2/temp1_input
#       - /sys/class/hwmon/hwmon2/temp3_input
#       - /sys/class/hwmon/hwmon2/temp4_input
#     interval: 5
#     format: '{icon}'
#     tooltip-format: '{temperatureC}°C'
#     format-icons:
#       - 
#       - 
#       - 
#     tooltip: true
#     on-click: swaymsg exec "\$once \$term_float -e watch -n 1 -p sensors"
#     exec-if: '[ "$(/sys/class/hwmon/hwmon2/name)" = "coretemp" ]'
  
#   temperature: &temperature-2
#     critical-threshold: 90
#     thermal-zone: 6
#     interval: 5
#     format: '{icon}'
#     tooltip-format: '{temperatureC}°C'
#     format-icons:
#       - 
#       - 
#       - 
#     tooltip: true
#     on-click: swaymsg exec "\$once \$term_float -e watch -n 1 -p sensors"
#     exec-if: '[ "$(cat /sys/class/thermal/thermal_zone6/type)" = "B0D4" ]'
  
#   custom/menu: &custom-menu
#     format: <span size="14pt">  󰇙</span>
#     on-click: swaymsg exec "\$menu"
#     on-click-right: swaymsg exec "\$rmenu"
#     tooltip: false
  
#   sway/language: &sway-language
#     format:  {}
#     min-length: 5
#     tooltip: false
#     on-click: swaymsg input $(swaymsg -t get_inputs --raw | jq '[.[] | select(.type == "keyboard")][0] | .identifier') xkb_switch_layout next
  
#   custom/clipboard: &custom-clipboard
#     format: 󰨸
#     interval: once
#     return-type: json
#     on-click: swaymsg -q exec '$clipboard'; pkill -RTMIN+9 waybar
#     on-click-right: swaymsg -q exec '$clipboard-del'; pkill -RTMIN+9 waybar
#     on-click-middle: rm -f ~/.cache/cliphist/db; pkill -RTMIN+9 waybar
#     exec: printf '{"tooltip":"%s"}' "$(cliphist list | wc -l) item(s) in the clipboard\r(Mid click to clear)"
#     signal: 9
  
#   custom/zeit: &custom-zeit
#     return-type: json
#     interval: once
#     format: '{icon}'
#     format-icons:
#       tracking: 󰖷
#       stopped: 󰋣
#     exec: /bin/sh $HOME/.config/sway/scripts/zeit.sh status
#     on-click: /bin/sh $HOME/.config/sway/scripts/zeit.sh click; pkill -RTMIN+10 waybar
#     exec-if: '[ -x "$(command -v zeit)" ]'
#     signal: 10

# bars:
#   - id: main
#     name: main
#     layer: bottom
#     margin: 0px 5px 0px 5px
#     height: 30
#     position: top
#     output: '*'
#     modules-left:
#       - sway/workspaces
#     modules-center:
#       - custom/mode-clock
#     modules-right:
#       - custom/wf-recorder
#       - privacy
#       - network
#       - custom/github
#       - custom/clipboard
#       - custom/zeit
#       - temperature
#       - cpu
#       - memory
#       - tray
#       - idle_inhibitor
#       - custom/adaptive-light
#       - custom/sunset
#       - custom/vpn
#       - custom/focus-follows-mouse
#       - custom/builtin-keyboard-stealth
#       - custom/bluetooth-device-airloop
#       - custom/bluetooth-device-sony
#       - backlight
#       - battery
#       - wireplumber
#       - custom/notification

#     wireplumber: *wireplumber
#     sway/workspaces: *sway-workspaces
#     custom/mode-clock: *custom-mode-clock
#     privacy: *privacy
#     custom/wf-recorder: *custom-wf-recorder
#     custom/clipboard: *custom-clipboard
#     custom/zeit: *custom-zeit
#     temperature: *temperature-1
#     temperature: *temperature-2
#     cpu: *cpu
#     memory: *memory
#     network: *network
#     tray: *tray
#     custom/github: *custom-github
#     idle_inhibitor: *idle-inhibitor
#     custom/adaptive-light: *custom-adaptive-light
#     custom/sunset: *custom-sunset
#     custom/vpn: *custom-vpn
#     custom/focus-follows-mouse: *custom-focus-follows-mouse
#     custom/builtin-keyboard-stealth: *custom-builtin-keyboard-stealth
#     custom/bluetooth-device-airloop: *custom-bluetooth-device-airloop
#     custom/bluetooth-device-sony: *custom-bluetooth-device-sony
#     backlight: *backlight
#     battery: *battery
#     custom/notification: *custom-notification
  
#   - id: side
#     name: side
#     layer: bottom
#     margin: 0px 5px 0px 5px
#     height: 30
#     position: top
#     output: []
#     modules-left: []
#     modules-center:
#       - sway/workspaces
#     modules-right: []
#     sway/workspaces: *sway-workspaces

let
  modules = {
  };
in
{
}
