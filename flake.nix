{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-emacs.url = "github:NixOS/nixpkgs/0bdc42a739c7bc234a934ce71417818224edc8b4";

    secrets.url = "git+ssh://git@github.com/arekisannda/nixos-secrets.git?ref=main&shallow=1";
    secrets.flake = false;

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    flake-parts.url = "github:hercules-ci/flake-parts";

    custompkgs.url = "github:arekisannda/nixos-packages";
    custompkgs.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.7.0";
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
              stateVersion = "26.05";
            }
          )
          [
            ./flake-parts/overlays.nix
            ./flake-parts/nixos.nix
            ./flake-parts/home-manager.nix
            ./flake-parts/iso.nix
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
          _module.args.custompkgs = inputs'.custompkgs.packages;

          devShells.default = pkgs.mkShell {
            name = "nix development shell";
            buildInputs = with pkgs; [
              gitleaks
              statix
              deadnix
              nixos-anywhere
              nvd
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
