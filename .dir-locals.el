((nil
  . ((eglot-workspace-configuration
      . ( :Lua ( :workspace ( :checkThirdParty nil
                              :ignoreDir [ ".direnv" "result" ] ))

          :nixd ( :nixpkgs ( :expr "import <nixpkgs> { }" )
                  :formatting ( :command [ "nixfmt" ] )
                  :options
                  ( :nixos
                    ( :expr "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.fw13.options" )
                    :home-manager
                    ( :expr "(builtins.getFlake (builtins.toString ./.)).currentSystem.legacyPackages.homeConfigurations.arekisannda.options" )
                    ))
          )
      )

     (util/commands-command-list
      . (("Rebuild NixOS Configurations Test" . "sudo nixos-rebuild dry-build --show-trace --flake /etc/nixos#${hostname}")
         ("Rebuild NixOS Configurations" . "sudo nixos-rebuild switch --show-trace --flake /etc/nixos#${hostname}")
         ("Rebuild Home Configurations" . "nix run --show-trace /etc/nixos#homeConfigurations.${USER}.activationPackage")
         ("Rebuild Home Configurations Test" . "nix build --dry-run --show-trace /etc/nixos#homeConfigurations.${USER}.activationPackage")
         ("Garbage Collect" . "sudo nix-collect-garbage -d -v && nix-collect-garbage -d -v")
         )))
  ))
