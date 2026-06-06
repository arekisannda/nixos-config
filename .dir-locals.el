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
          )
      )

     (nix-flake-iso-targets
      . (lambda ()
          (if-let* ((flake-root (locate-dominating-file default-directory "flake.nix")))
              (mapcar #'file-name-sans-extension (directory-files (expand-file-name "iso/" flake-root) nil "\\`[^.]"))
            (user-error "Not a flake project"))))

     (nix-flake-build-iso
      . (lambda (extra-args)
          (if-let* ((iso-targets (and (boundp 'nix-flake-iso-targets)
                                      (functionp nix-flake-iso-targets)
                                      (funcall nix-flake-iso-targets)))
                    (selected (completing-read "targets: " iso-targets)))
              (detached-shell-command
               (format "nix build %s --show-trace /etc/nixos#images.%s" extra-args selected))
            (user-error "Unable to find ISO target"))))

     (util/commands-command-list
      . (("Rebuild NixOS Configurations Test" . "nixos-rebuild --sudo dry-build --show-trace --flake /etc/nixos#${HOST}")
         ("Rebuild NixOS Configurations" . "nixos-rebuild --sudo switch --show-trace --flake /etc/nixos#${HOST}")
         ("Rebuild Home Configurations" . "nix run --show-trace /etc/nixos#homeConfigurations.${USER}.${HOST}.activationPackage")
         ("Rebuild Home Configurations Test" . "nix build --dry-run --show-trace /etc/nixos#homeConfigurations.${USER}.${HOST}.activationPackage")
         ("Run Garbage Collection" . "sudo nix-collect-garbage -d -v && nix-collect-garbage -d -v")
         ("Run Build ISO Test" . (lambda () (funcall nix-flake-build-iso "--dry-run")))
         ("Run Build ISO" . (lambda () (funcall nix-flake-build-iso "")))
         ))
     ))

 ("hardware/media"
  . ((nil
      . ((eval
          . (setq-local
             util/commands-command-list
             (append
              util/commands-command-list
              '(("Rebuild Media Configurations Test" . "nixos-rebuild --sudo dry-build --target-host media.mgmt --show-trace --flake /etc/nixos#media")
                ("Rebuild Media Configurations" . "nixos-rebuild --sudo switch --target-host media.mgmt --show-trace --flake /etc/nixos#media")
                ))
             ))
         )
      ))
  )
 )
