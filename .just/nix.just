# DO NOT EDIT. Local changes will be overwritten on the next update and will put
# this file out of sync with the template. Add project-specific recipes to the
# project's justfile instead, or change the template upstream.
#
# Source:  github:arekisannda/templates#flake
# Update:  just init (nix flake --refresh -t github:arekisannda/templates#flake

nix := require('nix')
nixos-rebuild := require('nixos-rebuild')
fzf := require('fzf')

_flake_lock := justfile_directory() / "flake.lock"

_inputs_expr := replace('''
  let
    lock = builtins.fromJSON (builtins.readFile "@LOCK@");
    inputs = lock.nodes.root.inputs;
  in
    builtins.concatStringsSep "\n" (builtins.attrNames inputs)
''', "@LOCK@", _flake_lock)

[doc('update Nix Flake Input')]
[group('flake')]
update-inputs *inputs:
    #!/usr/bin/env bash

    set -euo pipefail

    if [ ! -f {{ quote(_flake_lock) }} ]; then
        echo "Unable to find flake"
        exit 1
    fi

    inputs={{ quote(inputs) }}

    if [[ -z $inputs ]]; then
        inputs=$({{nix}} eval --raw --impure --expr {{quote(_inputs_expr)}} | {{fzf}} --multi --prompt "inputs: ")
    fi

    {{ nix }} flake update ${inputs}

