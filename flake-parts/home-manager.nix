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
        self.homeModules.sops
        (import "${usersDir}/${user}/home.nix")
      ];
    });
in
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeModules.userOptions = import ../options.nix;

  flake.homeModules.sops =
    { username, ... }:
    {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      sops = {
        defaultSopsFile = "${inputs.secrets}/secrets/${username}.yaml";
        validateSopsFiles = false;

        gnupg.home = "/home/${username}/.gnupg";
        gnupg.sshKeyPaths = [];
      };
    };

  perSystem =
    {
      pkgs,
      nixpkgs-unstable,
      nixpkgs-emacs,
      custompkgs,
      ...
    }:
    {
      legacyPackages.homeConfigurations = listToAttrs (
        map (user: {
          name = user;
          value = makeConfiguration {
            inherit pkgs user;

            extraSpecialArgs = {
              inherit self nixpkgs-unstable nixpkgs-emacs custompkgs;
              stateVersion = args.stateVersion;
              username = user;
            };
          };
        }) users
      );
    };
}
