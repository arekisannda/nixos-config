args:

{
  self,
  withSystem,
  inputs,
  ...
}:

let
  inherit (builtins)
    attrNames
    readDir
    listToAttrs
    map
    ;

  hardwareDir = ../hardware;
  hardwares = (attrNames (readDir hardwareDir));

  makeConfiguration =
    { type, ... }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        nixos-hardware = inputs.nixos-hardware.nixosModules;
        stateVersion = args.stateVersion;
        hardwareType = type;
      };

      modules = [
        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko

        self.nixosModules.nixSettings
        self.nixosModules.configureHardware
        self.nixosModules.sops
        self.nixosModules.pinNixpkgs
      ];
    };
in
{
  flake.nixosModules.nixSettings =
    { ... }:
    {
      # Nix Settings
      nix.settings.trusted-users = [
        "arekisannda"
      ];

      security.sudo.extraConfig = ''
        Defaults timestamp_type=global
      '';

      nix.nixPath = [
        "nixpkgs=${inputs.nixpkgs}"
        "nixpkgs-unstable=${inputs.nixpkgs-unstable}"
      ];

      nix.registry = {
        nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
      };

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      # nix.settings.auto-optimize-store = true;
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };

  flake.nixosModules.pinNixpkgs =
    { config, ... }:
    {
      nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system ({ pkgs, ... }: pkgs);
    };

  flake.nixosModules.configureHardware =
    { hardwareType, ... }:
    {
      imports = [
        # (import ../hardware/${hardwareType}/disko.nix)
        (import ../hardware/${hardwareType}/configuration.nix { users = [ ] ++ args.users; })
      ];
    };

  flake.nixosModules.sops =
    { hardwareType, ... }:
    {
      sops = {
        defaultSopsFile = "${inputs.secrets}/secrets/${hardwareType}.yaml";

        age = {
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          keyFile = "/var/lib/sops-nix/key.txt";
          generateKey = true;
        };
      };
    };

  flake.nixosConfigurations = listToAttrs (
    map (hw: {
      name = hw;
      value = makeConfiguration { type = hw; };
    }) hardwares
  );
}
