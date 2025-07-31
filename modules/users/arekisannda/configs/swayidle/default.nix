{ pkgs, ... }:

let
  timeout = {
    idle = 300;
    lock = 900;
    screen = 1200;
    sleep = 1800;
  };

  delay.sleep = 2;

  bin = {
    light = "${pkgs.light}/bin/light";
    lock = "${pkgs.swaylock-effects}/bin/swaylock";
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    cat = "${pkgs.coreutils}/bin/cat";
    swaymsg = "${pkgs.sway}/bin/swaymsg";
  };
in
{
  services.swayidle = {
    enable = true;

    events = [
      { event = "before-sleep"; command = "${bin.playerctl} pause"; }
      { event = "before-sleep"; command = "exec ${bin.lock} & sleep ${toString delay.sleep}"; }
    ];

    timeouts = [
      {
        timeout = timeout.idle;
        command = "${bin.light} -G > /tmp/brightness && ${bin.light} -S 10";
        resumeCommand = "${bin.light} -S $([ -f /tmp/brightness ] && ${bin.cat} /tmp/brightness || echo 100%)";
      }
      {
        timeout = timeout.lock;
        command = "exec ${bin.lock}";
      }
      {
        timeout = timeout.screen;
        command = "${bin.swaymsg} 'output * dpms off'";
        resumeCommand = "${bin.swaymsg} 'output * dpms on'";
      }
      {
        timeout = timeout.sleep;
        command = "sleep ${toString delay.sleep}; /run/current-system/sw/bin/systemctl suspend";
      }
    ];
  };
}
