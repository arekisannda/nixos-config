{ pkgs, ... }:

let
  timeout = {
    idle = 300;
    lock = 600;
    screen = 900;
    sleep = 1800;
  };

  bin = {
    cat = "${pkgs.coreutils}/bin/cat";
    light = "${pkgs.light}/bin/light";
    pgrep = "${pkgs.procps}/bin/pgrep";
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    sleep = "${pkgs.coreutils}/bin/sleep";
    swaymsg = "${pkgs.sway}/bin/swaymsg";
    systemctl = "${pkgs.systemd}/bin/systemctl";
    loginctl = "${pkgs.systemd}/bin/loginctl";
  };
in
{
  services.swayidle = {
    enable = true;

    systemdTarget = "sway-session.target";

    events = [
      {
        event = "lock";
        command = "${bin.systemctl} --user is-active sway-lockscreen.service || ${bin.systemctl} --user start sway-lockscreen.service";
      }
      {
        event = "before-sleep";
        command = "${bin.playerctl} -a pause";
      }
      {
        event = "before-sleep";
        command = "${bin.loginctl} lock-session";
      }
    ];

    timeouts = [
      {
        timeout = timeout.idle;
        command = "${bin.light} -G > /tmp/brightness && ${bin.light} -S 10";
        resumeCommand = "${bin.light} -S $([ -f /tmp/brightness ] && ${bin.cat} /tmp/brightness || echo 100%)";
      }
      {
        timeout = timeout.lock;
        command = "${bin.loginctl} lock-session";
      }
      {
        timeout = timeout.sleep;
        command = "${bin.systemctl} suspend";
      }
    ];
  };
}
