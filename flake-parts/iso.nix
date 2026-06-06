args:

{
  self,
  inputs,
  lib,
  config,
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

  isoDir = self.outPath + "/iso";
  isoTargets = map (file: replaceStrings [ ".nix" ] [ "" ] file) (attrNames (readDir "${isoDir}"));

  sshAuthorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMyKMfIeETcGHu9Q2UAvAsGCvuz1O+WUOWSXm+caTGoS"
  ];

  getTargetSystem =
    name: lib.findFirst (s: lib.hasPrefix s name) (throw "unknown system: ${name}") config.systems;

  makeISO =
    { target, ... }:
    let
      lib = inputs.nixpkgs.lib;
    in
    lib.nixosSystem {
      specialArgs = {
        inherit target;
      };

      system = getTargetSystem target;

      modules = [
        self.nixosModules.configureISO
      ];
    };
in
{

  flake.nixosModules.configureISO =
    { lib, target, ... }:
    let
      isoPath = "${isoDir}/${target}.nix";
    in
    {
      imports = lib.optional (pathExists isoPath) (import isoPath { inherit sshAuthorizedKeys; });
    };

  flake.images = listToAttrs (
    map (target: {
      name = target;
      value = (makeISO { target = target; }).config.system.build.isoImage;
    }) isoTargets
  );
}
