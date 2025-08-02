{ pkgs, inputs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = "${inputs.self}/modules/users/arekisannda/configs/zsh";
        file = "p10k.zsh";
      }
    ];

    shellAliases = {
      ll = "ls -l";
      edit = "sudo -e";
      update = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
      update-dry = "sudo nixos-rebuild dry-build --flake /etc/nixos#$(hostname)";
      hmup = "nix run /etc/nixos#home.$(hostname).$USER.activationPackage";
      hmup-dry = "nix build --dry-run /etc/nixos#home.$(hostname).$USER.activationPackage";
      nixgc = "sudo nix-collect-garbage";

      nixls = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
      zload = "source ~/.zshrc";

      nixs   = "nix search nixpkgs";
      nixdev = "nix develop --command zsh";
      nixbld = "nix build";
      nixrun = "nix run";
      nixflk = "nix flake";

      ec = "emacsclient -c -n";
      er = "emacsclient -r -n";
      en = "emacsclient -n";
      et = "emacsclient -nw";
      emc = "emacs";

      sm = "swaymsg";
      git = "GPG_TTY=$(tty) git";
    };

    history = {
      size = 10000;
      ignoreAllDups = true;
      path = "$HOME/.zsh_history";
      ignorePatterns = ["rm *" "pkill *" "cp *"];
    };
  };
}
