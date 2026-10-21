((nil
  . ((eglot-workspace-configuration
      . ( :Lua ( :workspace ( :checkThirdParty nil
                              :ignoreDir [ ".direnv" "result" ] ))

          :nixd ( :nixpkgs ( :expr "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }" )
                  :formatting ( :command [ "nixfmt" ] )
                  :options
                  ( :nixos
                    ( :expr "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${builtins.replaceStrings [\"\n\"] [\"\"] (builtins.readFile /etc/hostname)}.options" )
                    :home-manager
                    ( :expr "(builtins.getFlake (builtins.toString ./.)).currentSystem.legacyPackages.homeConfigurations.${builtins.getEnv \"USER\"}.${builtins.replaceStrings [\"\n\"] [\"\"] (builtins.readFile /etc/hostname)}.options" )
                    )
                  )
          ))

     (util/commands-allow-additional-commands . nil)

     (nix-flake-iso-targets
      . (lambda ()
          (if-let* ((flake-root (locate-dominating-file default-directory "flake.nix")))
              (mapcar #'file-name-sans-extension (directory-files (expand-file-name "iso/" flake-root) nil "\\`[^.]"))
            (user-error "Not a flake project"))))

     (nix-flake-build-iso
      . (lambda (&optional command)
          (if-let* ((iso-targets (funcall nix-flake-iso-targets))
                    (selected (completing-read "ISO target: " iso-targets)))
              (detached-shell-command
               (format "%s %s" command selected))
            (user-error "Unable to find ISO target"))))

     (util/commands-command-list
      . (("Rebuild NixOS Configurations Test" . "just rebuild-nixos-test")
         ("Rebuild NixOS Configurations" . "just rebuild-nixos")
         ("Rebuild Home Configurations" . "just rebuild-home")
         ("Rebuild Home Configurations Test" . "just rebuild-home-test")
         ("Run Garbage Collection" . "just --yes collect-garbage")
         ("Run Build ISO Test" . (lambda () (funcall nix-flake-build-iso "just build-iso-test")))
         ("Run Build ISO" . (lambda () (funcall nix-flake-build-iso "just build-iso")))
         ("Update Nix Flake Inputs" . (lambda () (funcall #'nix-flake-update-inputs "just nix::update-inputs")))
         ))
     ))

 ("hardware/media"
  . ((nil
      . ((eval
          . (setq-local
             util/commands-command-list
             (append
              util/commands-command-list
              '(("Rebuild Media Configurations Test" . "just media::rebuild-nixos-test")
                ("Rebuild Media Configurations" . "just media::rebuild-nixos")
                ))
             ))
         )
      ))
  )

("hardware/runner"
  . ((nil
      . ((eval
          . (setq-local
             util/commands-command-list
             (append
              util/commands-command-list
              '(("Rebuild Runner Configurations Test" . "just runner::rebuild-nixos-test")
                ("Rebuild Runner Configurations" . "just runner::rebuild-nixos")
                ))
             ))
         )
      ))
  )
 )
