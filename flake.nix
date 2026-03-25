{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-emacs.url = "github:NixOS/nixpkgs/5e4522be6bdf1600682a6f383434b057b2d77a37";

    secrets.url = "git+ssh://git@github.com/arekisannda/nixos-secrets.git?ref=main&shallow=1";
    secrets.flake = false;

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    flake-parts.url = "github:hercules-ci/flake-parts";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
          inputs',
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

          apps.format = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "format" ''
                if [ -z "$1" ]; then
                  echo "Usage: nix run .#format -- <path-to-disko-config>"
                  exit 1
                fi

                echo "WARNING: This will destroy all data on the disks defined in $1"
                read -p "Are you sure? (yes/no): " confirm
                if [ "$confirm" != "yes" ]; then
                  echo "Aborting"
                  exit 1
                fi

                sudo ${inputs'.disko.packages.disko}/bin/disko \
                  --mode destroy,format,mount \
                 "$1"
              ''
            );
          };
        };

      # hack to access home-manager options for lsp;
      debug = true;
    };
}
