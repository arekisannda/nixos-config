{
  self,
  pkgs,
  lib,
  ...
}:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh.enable = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = "${self}/modules/users/arekisannda/configs/zsh";
        file = "p10k.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    shellAliases = {
      ll = "ls -l";
      edit = "sudo -e";
      update = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
      update-dry = "sudo nixos-rebuild dry-build --flake /etc/nixos#$(hostname)";
      hmup = "nix run /etc/nixos#homeConfigurations.$USER";
      hmup-dry = "nix build --dry-run /etc/nixos#homeConfigurations.$USER";
      nixls = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
      nixgc = "sudo nix-collect-garbage -d -v && nix-collect-garbage -d -v";

      nsch = "nix search nixpkgs";
      ndev = "nix develop --command zsh";
      ndevr = "nix develop --command";
      nbld = "nix build";
      nrun = "nix run";
      nflk = "nix flake";

      ec = "emacsclient -c -n";
      er = "emacsclient -r -n";
      en = "emacsclient -n";
      et = "emacsclient -nw";
      emc = "emacs";

      sm = "swaymsg";
      git = "GPG_TTY=$(tty) git";

      zload = "source ~/.zshrc";
    };

    history = {
      size = 10000;
      ignoreAllDups = true;
      path = "$HOME/.zsh_history";
      ignorePatterns = [
        "rm *"
        "pkill *"
        "cp *"
      ];
    };

    initContent =
      let
        dev_shell_prompt = lib.mkOrder 1000 ''
          prompt_dev_shell() {
            [[ -n "$DEV_SHELL" ]] || return
            p10k segment -b blue -f white -t "($DEV_SHELL)"
          }
        '';
      in
      lib.mkMerge [ dev_shell_prompt ];
  };
}
