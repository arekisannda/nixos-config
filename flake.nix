{
  description = "NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-latest.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-emacs.url = "github:NixOS/nixpkgs/4eaa9a5a6aa1b7772519af4d8b25e7c44177d3d6";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-latest,
      nixpkgs-emacs,
      nixos-hardware,
      home-manager,
      ...
    }@inputs:
    let
      stateVersion = "25.11";

      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs allSystems (
          system:
          f {
            inherit system;
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = forAllSystems (
        { pkgs, ... }:
        {
          default = pkgs.mkShell {
            name = "nix development shell";
            buildInputs = with pkgs; [
              gitleaks
              nixfmt
              treefmt
              statix
              deadnix
            ];

            DEV_SHELL = "nixos";

            shellHook = "";
          };
        }
      );

      lspConfigurations.linux =
        let
          opts = {
            system = "x86_64-linux";
            modules = [ ];
          };
        in
        {
          nixpkgs = nixpkgs.lib.nixosSystem opts;
          nixpkgs-latest = nixpkgs-latest.lib.nixosSystem opts;
          nixpkgs-emacs = nixpkgs-emacs.lib.nixosSystem opts;
        };

      nixosConfigurations.fw13 =
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs stateVersion; };

          modules = [
            ./fw13/configuration.nix
            nixos-hardware.nixosModules.framework-amd-ai-300-series
          ];
        };

      homeConfigurations.fw13.arekisannda =
        let
          system = "x86_64-linux";
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."${system}";
          extraSpecialArgs = {
            inherit inputs stateVersion;
            nixpkgs = nixpkgs.legacyPackages."${system}";
            nixpkgs-unstable = nixpkgs-latest.legacyPackages."${system}";
            nixpkgs-emacs = nixpkgs-emacs.legacyPackages."${system}";
          };

          modules = [
            ./options.nix
            ./modules/users/arekisannda/home.nix
          ];
        };
    };
}
