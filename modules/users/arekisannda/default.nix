{ pkgs, ... }:

{
  programs.zsh.enable = true;
  users.groups.arekisannda = {};
  users.users.arekisannda = {
    isNormalUser = true;
    group = "arekisannda";
    extraGroups = [
      "docker"
      "input"
      "networkmanager"
      "nixos"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
}
