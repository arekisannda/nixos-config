{ config, pkgs, ... }:

{
  systemd.user.services = {
    "secure-session" = {
      Unit = {
        Description = "Lock GPG agent and lock encrypted directory on session lock";
        Before = [ "sleep.target" ];
      };
      Install = {
        WantedBy = [ "sleep.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "lock-agents.sh" ''
          for f in  ${config.xdg.configHome}/secure-session/*.sh; do
            [[ -f "$f" ]] && bash "$f"
          done
          ${pkgs.libnotify}/bin/notify-send  -e \
            -h "string:synchronous:secure-session" \
            -i 'lock' \
            'Secure Session' \
            'Locked agents and encrypted directories'
        '';
      };
    };
  };
}
