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
    notify-send = "${pkgs.libnotify}/bin/notify-send";
  };
in
{
  services.hypridle = {
    enable = true;
    systemdTarget = "sway-session.target";

    settings = {
      general = {
        inhibit_sleep = 1;
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
        ignore_wayland_inhibit = false;
        lock_cmd = "${bin.systemctl} --user is-active sway-lockscreen.service || ${bin.systemctl} --user start sway-lockscreen.service";
        unlock_cmd = "";
        before_sleep_cmd = "${bin.loginctl} lock-session";
      };

      listener = [
        {
          timeout = timeout.idle;
          on-timeout = "${bin.light} -G > /tmp/brightness && ${bin.light} -S 10";
          on-resume = "${bin.light} -S $([ -f /tmp/brightness ] && ${bin.cat} /tmp/brightness || echo 100%)";
        }
        {
          timeout = timeout.lock;
          on-timeout = "${bin.loginctl} lock-session";
        }
        {
          timeout = timeout.sleep;
          on-timeout = "${bin.systemctl} suspend";
        }
      ];
    };
  };
}
