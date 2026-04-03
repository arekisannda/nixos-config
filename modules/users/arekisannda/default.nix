{ pkgs, config, ... }:

{
  sops.secrets.arekisannda_passwd = {
    key = "users/arekisannda/password";
    neededForUsers = true;
  };

  programs.zsh.enable = true;
  users.groups.arekisannda = { };
  users.users.arekisannda = {
    hashedPasswordFile = config.sops.secrets.arekisannda_passwd.path;
    isNormalUser = true;
    group = "arekisannda";
    extraGroups = [
      "docker"
      "input"
      "networkmanager"
      "nixos"
      "plugdev"
      "storage"
      "users"
      "video"
      "wheel"
      "wireshark"
    ];
    shell = pkgs.zsh;
  };
}
