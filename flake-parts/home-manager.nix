args:

{ self, inputs, ... }:

let
  inherit (builtins)
    attrNames
    readDir
    listToAttrs
    ;

  modulesDir = ../modules;
  usersDir = "${modulesDir}/users";
  users = (attrNames (readDir usersDir));

  makeConfiguration =
    {
      pkgs,
      extraSpecialArgs,
      user,
      ...
    }:

    (inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs extraSpecialArgs;
      modules = [
        self.homeModules.userOptions
        (import "${usersDir}/${user}/home.nix")
      ];
    }).activationPackage;
in
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeModules.userOptions = import ../options.nix;

  perSystem =
    {
      pkgs,
      nixpkgs-unstable,
      nixpkgs-emacs,
      ...
    }:
    {
      legacyPackages.homeConfigurations = listToAttrs (
        map (user: {
          name = user;
          value = makeConfiguration {
            inherit pkgs user;

            extraSpecialArgs = {
              inherit self nixpkgs-unstable nixpkgs-emacs;
              stateVersion = args.stateVersion;
            };
          };
        }) users
      );
    };
}
