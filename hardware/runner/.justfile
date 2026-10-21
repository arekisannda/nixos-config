home := env('HOME')
user := env('USER')
host := env('RUNNER_HOST')

nix := require('nix')
nixos-rebuild := require('nixos-rebuild')

[group('nixos')]
_rebuild-nixos dry:
    {{ nixos-rebuild }} --sudo {{ if dry == "true" { "dry-build" } else { "switch" } }} --show-trace --target-host "{{ host }}" --flake /etc/nixos#media

[doc('Rebuild Media Configuration')]
[group('nixos')]
rebuild-nixos: (_rebuild-nixos "false")

[doc('Rebuild Media Configuration Test')]
[group('nixos')]
rebuild-nixos-test: (_rebuild-nixos "true")
