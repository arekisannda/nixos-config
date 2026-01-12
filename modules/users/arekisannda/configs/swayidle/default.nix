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
    gpgconf = "${pkgs.gnupg}/bin/gpgconf";
    light = "${pkgs.light}/bin/light";
    lock = "${pkgs.swaylock-effects}/bin/swaylock";
    pgrep = "${pkgs.procps}/bin/pgrep";
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    sleep = "${pkgs.coreutils}/bin/sleep";
    swaymsg = "${pkgs.sway}/bin/swaymsg";
    systemctl = "${pkgs.systemd}/bin/systemctl";
  };
in {
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
        command = "${bin.gpgconf} --kill gpg-agent";
      }
      {
        event = "before-sleep";
        command =
          "if ! ${bin.pgrep} swaylock; then ${bin.lock} --daemonize; fi";
      }
    ];

    timeouts = [
      {
        timeout = timeout.idle;
        command = "${bin.light} -G > /tmp/brightness && ${bin.light} -S 10";
        resumeCommand =
          "${bin.light} -S $([ -f /tmp/brightness ] && ${bin.cat} /tmp/brightness || echo 100%)";
      }
      {
        timeout = timeout.lock;
        command = "${bin.gpgconf} --kill gpg-agent";
      }
      {
        timeout = timeout.lock;
        command =
          "if ! ${bin.pgrep} swaylock; then ${bin.lock} --daemonize; fi";
      }
      {
        timeout = timeout.sleep;
        command = "${bin.systemctl} suspend";
      }
    ];
  };
}
