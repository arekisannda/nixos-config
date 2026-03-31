((nil
  . ((eglot-workspace-configuration
      . ( :Lua ( :workspace ( :checkThirdParty nil
                              :ignoreDir [ ".direnv" "result" ] ))

          :nixd ( :nixpkgs ( :expr "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }" )
                  :formatting ( :command [ "nixfmt" ] )
                  :options
                  ( :nixos
                    ( :expr "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${builtins.getEnv \"HOST\"}.options" )
                    :home-manager
                    ( :expr "(builtins.getFlake (builtins.toString ./.)).currentSystem.legacyPackages.homeConfigurations.${builtins.getEnv \"USER\"}.options" )
                    ))
          )
      )

     (util/commands-command-list
      . (("Rebuild NixOS Configurations Test" . "nixos-rebuild --sudo dry-build --show-trace --flake /etc/nixos#${HOST}")
         ("Rebuild NixOS Configurations" . "nixos-rebuild --sudo switch --show-trace --flake /etc/nixos#${HOST}")
         ("Rebuild Home Configurations" . "nix run --show-trace /etc/nixos#homeConfigurations.${USER}.activationPackage")
         ("Rebuild Home Configurations Test" . "nix build --dry-run --show-trace /etc/nixos#homeConfigurations.${USER}.activationPackage")
         ("Garbage Collect" . "sudo nix-collect-garbage -d -v && nix-collect-garbage -d -v")
         )))
  ))
