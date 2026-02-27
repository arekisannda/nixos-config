{
  description = "NixOS Configuration";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-emacs.url = "github:NixOS/nixpkgs/4eaa9a5a6aa1b7772519af4d8b25e7c44177d3d6";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      imports =
        map
          (
            e:
            import e {
              stateVersion = "25.11";
              users = [ "arekisannda" ];
            }
          )
          [
            ./flake-parts/overlays.nix
            ./flake-parts/nixos.nix
            ./flake-parts/home-manager.nix
          ];

      perSystem =
        {
          lib,
          system,
          pkgs,
          ...
        }:

        let
          mkPackages =
            input:
            import input {
              inherit system;
              overlays = lib.attrValues self.overlays;
              config.allowUnfree = true;
            };
        in
        {
          _module.args.pkgs = mkPackages inputs.nixpkgs;
          _module.args.nixpkgs-unstable = mkPackages inputs.nixpkgs-unstable;
          _module.args.nixpkgs-emacs = mkPackages inputs.nixpkgs-emacs;

          devShells.default = pkgs.mkShell {
            name = "nix development shell";
            buildInputs = with pkgs; [
              gitleaks
              statix
              deadnix
            ];

            DEV_SHELL = "nixos";

            shellHook = "";
          };
        };
    };
}
