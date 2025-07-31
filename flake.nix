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
      system = "x86_64-linux";
    in {
      devShells.${system}.default =
        let
          pkgs = import nixpkgs { inherit system; };
        in pkgs.mkShell {
          name = "nix development shell";
          buildInputs = with pkgs; [
            nixd
            nixfmt-classic
            nixpkgs-fmt
            statix
            deadnix
          ];
          shellHook = ''
            export PROMPT=[$PROMPT]
            '';
        };

      nixosConfigurations.fw13 = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs stateVersion; };

        modules = [ ./fw13/configuration.nix ];
      };

      home.fw13.arekisannda =
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."${system}";
          extraSpecialArgs = { inherit inputs stateVersion; };

          modules = [ ./options.nix ./modules/users/arekisannda/home.nix ];
        };
    };
}
