args:

{ self, inputs, ... }:

let
  inherit (builtins)
    attrNames
    readDir
    listToAttrs
    replaceStrings
    ;

  usersDir = self.outPath + "/users";
  users = (attrNames (readDir usersDir));
  userProfiles =
    user:
    map (file: replaceStrings [ ".nix" ] [ "" ] file) (
      attrNames (readDir "${usersDir}/${user}/profiles")
    );

  makeConfiguration =
    {
      pkgs,
      extraSpecialArgs,
      user,
      profile,
      ...
    }:

    (inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs extraSpecialArgs;
      modules = [
        self.homeModules.userOptions
        self.homeModules.sops
        self.homeModules.flatpak
        (import "${usersDir}/${user}/profiles/${profile}.nix")
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
        gnupg.sshKeyPaths = [ ];
      };
    };

  flake.homeModules.flatpak =
    { pkgs, username, ... }:
    {
      imports = [
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
        (import "${usersDir}/${username}/flatpak/default.nix")
      ];

      home.packages = with pkgs; [
        flatpak
      ];
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
          value = listToAttrs (
            map (profile: {
              name = profile;
              value = makeConfiguration {
                inherit pkgs user profile;

                extraSpecialArgs = {
                  inherit
                    self
                    nixpkgs-unstable
                    nixpkgs-emacs
                    custompkgs
                    ;
                  utils = (import ../utils { });
                  stateVersion = args.stateVersion;
                  username = user;
                };
              };
            }) (userProfiles user)
          );

        }) users
      );
    };
}
