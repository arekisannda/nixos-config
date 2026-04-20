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
      nixls = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
      nixgc = "sudo nix-collect-garbage -d -v && nix-collect-garbage -d -v";
      nsch = "nix search";

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
        "zathura *"
        "imv *"
        "mpv *"
        "yt-dlp *"
        "pass *"
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
