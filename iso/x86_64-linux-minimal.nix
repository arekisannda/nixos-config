{ sshAuthorizedKeys, ... }:

{ pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = sshAuthorizedKeys;

  environment.systemPackages = [ pkgs.neovim ];
  boot.zfs.forceImportRoot = false;
}
