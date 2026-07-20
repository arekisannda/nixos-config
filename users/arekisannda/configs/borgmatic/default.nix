{
  config,
  pkgs,
  lib,
  ...
}:

let
  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
{
  sops.secrets.borg.key = "services/borgmatic/passphrase";

  programs.borgmatic = {
    enable = true;
    backups =
      let
        locationPatterns = [
          "R ${config.home.homeDirectory}"
          "- ${config.home.homeDirectory}/Books"
          "- ${config.home.homeDirectory}/Music"
          "- ${config.home.homeDirectory}/Downloads"
          "- ${config.home.homeDirectory}/Desktop"
          "- ${config.home.homeDirectory}/.var"
          "- ${config.home.homeDirectory}/.cache"
          "- ${config.home.homeDirectory}/.encrypted"
          "- ${config.home.homeDirectory}/.thunderbird"
          "- ${config.home.homeDirectory}/.local/share/Steam"
          "- ${config.home.homeDirectory}/.local/share/flatpak"
          "- ${config.home.homeDirectory}/.local/share/docker/overlay2"
          "- ${config.home.homeDirectory}/.local/share/docker/image"
          "- ${config.home.homeDirectory}/.local/share/docker/containers"
          "- ${config.home.homeDirectory}/.local/share/docker/buildkit"
          "- ${config.home.homeDirectory}/.local/share/docker/tmp"
          "- ${config.home.homeDirectory}/.local/mnt"
        ];

        storage = {
          encryptionPasscommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets.borg.path}";
        };

        retention = {
          keepWithin = "3H";
          keepDaily = 7;
          keepWeekly = 4;
          keepMonthly = 6;
        };

        hooks = {
          extraConfig = {
            commands = [
              {
                before = "action";
                when = [ "create" ];
                run = [
                  "${notify-send} -h \"string:synchronous:borg\" --transient -t 5000 \"Borg {repository_label}\" \"Creating backup {repository}\""
                ];
              }
              {
                after = "action";
                when = [ "create" ];
                states = [ "finish" ];
                run = [
                  "${notify-send} -h \"string:synchronous:borg\" --transient -t 5000 \"Borg {repository_label}\" \"Completed backup {repository}\""
                ];
              }
              {
                after = "error";
                run = [
                  "${notify-send} -t 5000 \"Borg {repository_label}\" {error}"
                ];
              }
            ];
          };
        };

        output = {
          extraConfig = {
            borg_exit_codes = [
              {
                code = 105;
                treat_as = "warning";
              }
            ];
          };
        };
      in
      {
        backup = {
          inherit
            storage
            retention
            hooks
            output
            ;
          location = {
            patterns = locationPatterns;
            repositories = [
              {
                "path" = "/run/media/${config.home.username}/backup/borg";
                "label" = "backup";
              }
            ];
          };
        };

        recovery_alpha = {
          inherit
            storage
            retention
            hooks
            output
            ;
          location = {
            patterns = locationPatterns;
            repositories = [
              {
                "path" = "/run/media/${config.home.username}/stasis_alpha";
                "label" = "stasis alpha";
              }
            ];
          };
        };

        recovery_beta = {
          inherit
            storage
            retention
            hooks
            output
            ;
          location = {
            patterns = locationPatterns;
            repositories = [
              {
                "path" = "/run/media/${config.home.username}/stasis_beta";
                "label" = "stasis beta";
              }
            ];
          };
        };
      };
  };

  services.borgmatic = {
    enable = true;
    frequency = "*-*-* 12:00:00";
  };

  systemd.user.services.borgmatic.Service.ExecStart = lib.mkForce ''
    ${pkgs.systemd}/bin/systemd-inhibit \
      --who="borgmatic" \
      --what="sleep:shutdown" \
      --why="Prevent interrupting scheduled backup" \
      ${config.programs.borgmatic.package}/bin/borgmatic \
        --config ${config.xdg.configHome}/borgmatic.d/backup.yaml \
        --stats \
        --verbosity -1 \
        --list \
        --syslog-verbosity 1
  '';

}
