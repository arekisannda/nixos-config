{
  description = "NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      stateVersion = "25.05";

      allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
      });
    in {
      devShells = forAllSystems({ pkgs, system }:
        {
          default = pkgs.mkShell {
            name = "nix development shell";
            buildInputs = with pkgs; [
              nixd
              nixfmt-classic
              nixpkgs-fmt
              statix
              deadnix
            ];
            shellHook = ''
              echo 'Nix Development System: ${system}'
              export DEV_SHELL=1

              if [[ -n "$DEV_SHELL" ]]; then
                PROMPT="[%{$reset_color%}\$PROMPT]"
              fi
            '';
          };
        });

      nixosConfigurations.fw13 = let
        system = "x86_64-linux";
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs stateVersion; };

        modules = [ ./fw13/configuration.nix ];
      };

      home.fw13.arekisannda = let
        system = "x86_64-linux";
      in home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."${system}";
        extraSpecialArgs = { inherit inputs stateVersion; };

        modules = [ ./options.nix ./modules/users/arekisannda/home.nix ];
      };
    };
}
