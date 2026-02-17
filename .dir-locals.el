((nil
  . ((eglot-workspace-configuration
      . ( :Lua ( :workspace ( :checkThirdParty nil
                              :ignoreDir [ ".direnv" "result" ] ))

          :nixd ( :nixpkgs ( :expr "import <nixpkgs> { }" )
                  :formatting ( :command [ "nixfmt" ] )
                  :options
                  ( :nixos
                    ( :expr "(builtins.getFlake (builtins.toString ./.)).lspConfigurations.linux.nixpkgs.options" )
                    :nixpkgs-latest
                    ( :expr "(builtins.getFlake (builtins.toString ./.)).lspConfigurations.linux.nixpkgs-latest.options" )
                    :nixpkgs-emacs
                    ( :expr "(builtins.getFlake (builtins.toString ./.)).lspConfigurations.linux.nixpkgs-emacs.options" )
                    :home-manager
                    ( :expr "(builtins.getFlake (builtins.toString ./.)).homeConfigurations.fw13.arekisannda.options" )
                    ))
          )
      ))
  ))
