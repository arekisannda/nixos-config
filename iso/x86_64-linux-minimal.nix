{ sshAuthorizedKeys, ... }:

{
  pkgs,
  lib,
  modulesPath,
  ...
}:

{
  build.lastModified = 1792113248;

  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  boot.kernelParams = [ "copytoram" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = lib.mkForce [
    "btrfs"
    "reiserfs"
    "vfat"
    "f2fs"
    "xfs"
    "ntfs"
    "cifs"
  ];

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = sshAuthorizedKeys;

  environment.systemPackages = [ pkgs.neovim ];
  boot.zfs.forceImportRoot = false;
}
