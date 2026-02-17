{ pkgs, nixpkgs-unstable, ... }:

let
  timeout = {
    idle = 300;
    lock = 900;
    screen = 1200;
    sleep = 1800;
  };

  delay.sleep = 2;

  bin = {
    cat = "${pkgs.coreutils}/bin/cat";
    light = "${pkgs.light}/bin/light";
    pgrep = "${pkgs.procps}/bin/pgrep";
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    sleep = "${pkgs.coreutils}/bin/sleep";
    swaymsg = "${pkgs.sway}/bin/swaymsg";
    systemctl = "${pkgs.systemd}/bin/systemctl";
  };
in
{
  services.swayidle = {
    enable = true;

    systemdTarget = "sway-session.target";

    events = [
      {
        event = "before-sleep";
        command = "${bin.playerctl} -a pause";
      }
      {
        event = "before-sleep";
        command = "${bin.systemctl} --user start swaylock.service";
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
        command = "${bin.systemctl} --user start swaylock.service";
      }
      {
        timeout = timeout.sleep;
        command = "${bin.systemctl} suspend";
      }
    ];
  };
}
