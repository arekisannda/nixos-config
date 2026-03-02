{
  description = "<description for the project>";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    template-utils.url = "github:arekisannda/nixos-config?dir=templates";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem =
        { system, pkgs, ... }:
        let
          getPackages =
            pkgs: with pkgs; [
              pkgs.hello
            ];
        in
        {
          _module.args.pkgs = import inputs.nixpkgs { inherit system; };

          devShells.default = pkgs.mkShell {
            name = "devshell";
            buildInputs = getPackages pkgs;

            DEV_SHELL = "<devshell tag>";

            shellHook = "";
          };

          devShells.fhs =
            (pkgs.buildFHSEnv {
              name = "FHS";
              targetPkgs = pkgs: (getPackages pkgs);
            }).env;
        };

      imports = [
        inputs.template-utils.modules.flake.devenv-setup
      ];
    };
}
