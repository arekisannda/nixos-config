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
                    ( :expr "(builtins.getFlake (builtins.toString ./.)).homeConfigurations.fw13.arekisannda.options" )
                    ))
          )
      ))
  ))
