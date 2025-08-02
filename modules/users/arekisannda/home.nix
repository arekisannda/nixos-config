{ config, pkgs, stateVersion, ... }@attr:

let
  username = "arekisannda";
  homeDirectory = "/home/${username}";
  importWithArgs = path: import path attr;
in {
  setup = {
    terminal = {
      type = "xterm-256color";
      theme = import ../../shared/themes/term/sonokai.nix;
    };

    gui = {
      theme = import ../../shared/themes/gui/yaru-grey.nix;

      wallpaper = {
        image = "$XDG_CONFIG_HOME/swaybg/gruvbox_cave.png";
        color = "282828";
        scaling = "center";
        lockscreenColor = "272727";
        lockscreenScaling = "center";
      };
    };
  };

  home = { inherit username stateVersion homeDirectory; };

  home.pointerCursor = {
    name = config.setup.gui.theme.cursor;
    package = pkgs.kdePackages.breeze;
    size = 10;
    x11 = {
      enable = true;
      defaultCursor = config.setup.gui.theme.cursor;
    };
    sway.enable = true;
  };

  imports = [
    (importWithArgs ./configs/gpg-agent)
    (importWithArgs ./configs/dconf)
    (importWithArgs ./configs/qt)
    (importWithArgs ./configs/alacritty)
    (importWithArgs ./configs/fzf)
    (importWithArgs ./configs/gh)
    (importWithArgs ./configs/gh-dash)
    (importWithArgs ./configs/ripgrep)
    (importWithArgs ./configs/swaylock)
    (importWithArgs ./configs/swayr)
    (importWithArgs ./configs/tmux)
    (importWithArgs ./configs/zsh)
    (importWithArgs ./configs/swayidle)
    (importWithArgs ./configs/swaync)
    (importWithArgs ./configs/rofi)
    (importWithArgs ./configs/sway)
    (importWithArgs ./configs/kvantum)
    (importWithArgs ./configs/yaru-colors)
  ];

  home.sessionVariables = {
    # VIRSH_DEFAULT_CONNECT_URI = "qemu:///system";
    # ZEIT_DB = "$HOME/.config/zeit.db";
    # Disable hardware cursors. This might fix issues with disappearing cursors
    EMACS_USER_DIRECTORY = "$XDG_CONFIG_HOME/emacs";
    DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock;
  };

  news.display = "silent";
}
