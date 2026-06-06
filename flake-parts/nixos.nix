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
    pathExists
    ;

  hardwareDir = self.outPath + "/hardware";
  hardwares = (attrNames (readDir hardwareDir));

  makeConfiguration =
    { hardwareName, ... }:
    let
      usersPath = "${hardwareDir}/${hardwareName}/users.nix";
      defaultsUsersConfig = {
        trusted-users = [ ];
        users = [ ];
      };
    in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        nixos-hardware = inputs.nixos-hardware.nixosModules;
        stateVersion = args.stateVersion;
        hardwareName = hardwareName;
        usersConfig =
          defaultsUsersConfig // (if builtins.pathExists usersPath then import usersPath else { });
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

  makeISO =
    { hardwareName, ... }:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        stateVersion = args.stateVersion;
        hardwareName = hardwareName;
      };

      modules = [
        self.nixosModules.configureISO
      ];
    };
in
{
  flake.nixosModules.nixSettings =
    { usersConfig, ... }:
    {
      # Nix Settings
      nix.settings.trusted-users = usersConfig.trusted-users;

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

      nix.settings.download-buffer-size = 536870912;

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
    {
      lib,
      hardwareName,
      usersConfig,
      ...
    }:
    let
      diskoPath = "${hardwareDir}/${hardwareName}/disko.nix";
      configurationPath = "${hardwareDir}/${hardwareName}/configuration.nix";
    in
    {
      imports =
        lib.optional (pathExists diskoPath) (import diskoPath)
        ++ lib.optional (pathExists configurationPath) (
          import configurationPath {
            users = usersConfig.users;
            modulesDir = self.outPath + "/modules";
            usersDir = self.outPath + "/users";
          }
        );
    };

  flake.nixosModules.configureISO =
    { lib, hardwareName, ... }:
    let
      isoPath = "${hardwareDir}/${hardwareName}/iso.nix";
    in
    {
      imports = lib.optional (pathExists isoPath) (import isoPath);
    };

  flake.nixosModules.sops =
    { hardwareName, ... }:
    {
      sops = {
        defaultSopsFile = "${inputs.secrets}/secrets/${hardwareName}.yaml";

        age = {
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          keyFile = "/var/lib/sops-nix/key.txt";
          generateKey = true;
        };
      };
    };

  flake.nixosConfigurations =
    listToAttrs (
      map (hw: {
        name = hw;
        value = makeConfiguration { hardwareName = hw; };
      }) hardwares
    )
    // listToAttrs (
      map (hw: {
        name = "${hw}-iso";
        value = makeISO { hardwareName = hw; };
      }) hardwares
    );
}
