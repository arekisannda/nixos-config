_args:

{
  self,
  inputs,
  lib,
  config,
  withSystem,
  ...
}:

let
  inherit (builtins)
    attrNames
    readDir
    listToAttrs
    replaceStrings
    pathExists
    ;

  utils = (import ../utils { });

  isoDir = self.outPath + "/iso";
  isoTargets = map (file: replaceStrings [ ".nix" ] [ "" ] file) (attrNames (readDir "${isoDir}"));

  sshAuthorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMyKMfIeETcGHu9Q2UAvAsGCvuz1O+WUOWSXm+caTGoS"
  ];

  getTargetSystem =
    name: lib.findFirst (s: lib.hasPrefix s name) (throw "unknown system: ${name}") config.systems;

  getTargetIdentifier = name: lib.removePrefix "${(getTargetSystem name)}-" name;

  makeISO =
    { target, ... }:
    let
      lib = inputs.nixpkgs-iso.lib;
    in
    lib.nixosSystem {
      specialArgs = {
        inherit target;
        nixpkgs-unstable = (
          withSystem (getTargetSystem target) ({ nixpkgs-iso-unstable, ... }: nixpkgs-iso-unstable)
        );
      };

      system = getTargetSystem target;

      modules = [
        self.nixosModules.isoOptions
        self.nixosModules.isoConfigure
      ];
    };
in
{
  flake.nixosModules.isoOptions =
    { lib, ... }:
    {
      options.build.lastModified = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Unix time this configuration was last modified.";
      };

      config = { };
    };

  flake.nixosModules.isoConfigure =
    {
      config,
      pkgs,
      lib,
      target,
      ...
    }:
    let
      isoPath = "${isoDir}/${target}.nix";
    in
    {
      # use `nixpkgs-iso` as pkg
      nixpkgs.pkgs = lib.mkForce (
        withSystem (getTargetSystem target) ({ nixpkgs-iso, ... }: nixpkgs-iso)
      );

      image.baseName = lib.mkForce (
        lib.concatStringsSep "-" [
          "nixos"
          (getTargetIdentifier target)
          config.system.nixos.label
          pkgs.stdenv.hostPlatform.system
          (utils.time.ISO8601 config.build.lastModified)
        ]
      );
      isoImage.volumeID = lib.mkForce "nixos";
      isoImage.squashfsCompression = "zstd";

      security.sudo.extraConfig = ''
        Defaults timestamp_type=global
      '';

      nix.nixPath = [
        "nixpkgs=${inputs.nixpkgs-iso}"
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

      imports = lib.optional (pathExists isoPath) (import isoPath { inherit sshAuthorizedKeys; });
    };

  flake.images = listToAttrs (
    map (target: {
      name = target;
      value = (makeISO { target = target; }).config.system.build.isoImage;
    }) isoTargets
  );
}
