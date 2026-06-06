{ config, pkgs, ... }:

let
  kodi-bundle = (
    with pkgs;
    (kodi-gbm.withPackages (
      p: with p; [
        bluetooth-manager
        jellycon
        joystick
      ]
    ))
  );
in
{
  environment.systemPackages = [
    kodi-bundle
  ];

  sops.secrets.kodi_passwd = {
    key = "users/kodi/password";
    neededForUsers = true;
  };

  users.users.kodi = {
    hashedPasswordFile = config.sops.secrets.root_passwd.path;
    extraGroups = [
      # allow kodi access to keyboards
      "input"
    ];
    isNormalUser = true;
  };

  # auto-login and launch kodi
  services.getty.autologinUser = "kodi";
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${kodi-bundle}/bin/kodi-standalone";
        user = "kodi";
      };
      default_session = {
        command = "${pkgs.greetd}/bin/agreety --cmd sway";
      };
    };
  };

  programs.sway = {
    enable = true;
    xwayland.enable = false;
  };
}
