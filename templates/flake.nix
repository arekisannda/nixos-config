{
  description = "Templates";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake.templates.devenv = {
        path = ./devenv;
        description = "A simple development environment flake";
      };

      flake.modules.flake = {
        devenv-setup =
          { ... }:
          {
            perSystem =
              { pkgs, ... }:
              {
                apps.devenv-setup = {
                  type = "app";
                  program = pkgs.writeShellScriptBin "devenv-setup" ''
                    [ -f .envrc ] && echo "Development environment configured." && exit 0

                    cat <<EOF > .envrc
                    use flake
                    EOF

                    direnv allow
                  '';
                };
              };
          };
      };
    };
}
