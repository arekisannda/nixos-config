mod? nix '.just/nix.just'
mod? media 'hardware/media/.justfile'
mod? runner 'hardware/runner/.justfile'

home := env('HOME')
user := env('USER')
host := env('HOST', `cat /etc/hostname`)

nix := require('nix')
nixos-rebuild := require('nixos-rebuild')
nix-collect-garbage := require('nix-collect-garbage')
fzf := require('fzf')

_just_mod_dir := justfile_directory() / ".just"

[confirm("Remove the existing module directory?")]
_remove-mod-dir:
    rm -rf {{ quote(_just_mod_dir) }}

init:
    #!/usr/bin/env bash
    set -euo pipefail

    if [ -d {{ quote(_just_mod_dir) }} ]; then
        {{ just_executable() }} --justfile {{ quote(justfile()) }} _remove-mod-dir
    fi

    {{ nix }} flake --refresh init -t github:arekisannda/templates#flake

[group('nixos')]
_rebuild-nixos dry:
    {{ nixos-rebuild }} --sudo {{ if dry == "true" { "dry-build" } else { "switch" } }} --show-trace --flake /etc/nixos#{{ host }}

[doc('Rebuild NixOS Configuration')]
[group('nixos')]
rebuild-nixos: (_rebuild-nixos "false")

[doc('Rebuild NixOS Configuration Test')]
[group('nixos')]
rebuild-nixos-test: (_rebuild-nixos "true")

[group('home-manager')]
_rebuild-home dry:
    {{ nix }} {{ if dry == "true" { "build --dry-run" } else { "run" } }} --show-trace /etc/nixos#homeConfigurations.{{ user }}.{{ host }}.activationPackage

[doc('Rebuild Home Configurations')]
[group('home-manager')]
rebuild-home: (_rebuild-home "false")

[doc('Rebuild Home Configurations Test')]
[group('home-manager')]
rebuild-home-test: (_rebuild-home "true")

[doc('Run Garbage Collection')]
collect-garbage:
    sudo {{nix-collect-garbage}} -d -v && nix-collect-garbage -d -v

[group('iso')]
_build-iso target dry:
    #!/usr/bin/env bash

    set -euo pipefail

    target={{ quote(target) }}

    if [ -z "$target" ]; then
        target=$(basename -s .nix iso/* | {{ fzf }} --prompt "ISO target: ")
    elif [ ! -f iso/$target.nix ]; then
        echo "Invalid target: ${target}" >&2
        exit 1
    fi

    {{ nix }} build {{ if dry == "true" { "--dry-run" } else { "" } }} --show-trace /etc/nixos#images.$target -o "result/${target}"
    echo "{{ if dry == "true" { "Test build" } else { "Built" } }} ${target}"

[doc('Build Target ISO')]
[group('iso')]
build-iso target="": (_build-iso target "false")

[doc('Build Target ISO Test')]
[group('iso')]
build-iso-test target="": (_build-iso target "true")

