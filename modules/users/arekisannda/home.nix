{ config, pkgs, nixpkgs-unstable, stateVersion, ... }@attr:

let
  username = "arekisannda";
  homeDirectory = "/home/${username}";
  importWithArgs = path: import path attr;
in {
  nixpkgs.config.allowUnfree = true;

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
        lockscreenColor = "282828";
        lockscreenScaling = "center";
      };
    };
  };

  home = { inherit username stateVersion homeDirectory; };

  home.pointerCursor = {
    name = config.setup.gui.theme.cursor;
    package = pkgs.kdePackages.breeze;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = config.setup.gui.theme.cursor;
    };
    sway.enable = true;
  };

  imports = [
    (import ../../packages)
    (importWithArgs ./configs/mime)
    (importWithArgs ./configs/firefox)
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
    (importWithArgs ./configs/themes)
    (importWithArgs ./configs/fcitx)
    (importWithArgs ./configs/mise)
    (importWithArgs ./configs/direnv)
    (importWithArgs ./configs/emacs)
    (importWithArgs ./configs/latex)
    (importWithArgs ./configs/mpv)
    (importWithArgs ./configs/swappy)
  ];

  home.sessionVariables = {
    # VIRSH_DEFAULT_CONNECT_URI = "qemu:///system";
    # ZEIT_DB = "$HOME/.config/zeit.db";
    BROWSER = "firefox";
    CALIBRE_USE_DARK_PALETTE = "1";
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
    EMACS_USER_DIRECTORY = "$XDG_CONFIG_HOME/emacs";
    GOPATH = "$HOME/.go";
    LSP_USE_PLISTS = "true";
  };

  home.file = let
    session-vars-file =
      "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh";
  in {
    ".profile".text = ''
      [ -f "${session-vars-file}" ] && . "${session-vars-file}"
    '';
  };

  home.packages = with pkgs; [
    anki-bin
    calibre
    dict
    discord-canary
    farge
    gparted
    imv
    nixpkgs-unstable.brave
    nixpkgs-unstable.firefoxpwa
    nixpkgs-unstable.openscad-unstable
    nixpkgs-unstable.yt-dlp
    polkit_gnome
    protonmail-bridge-gui
    steam
    thunderbird
    tridactyl-native
    vial
    vlc
    w3m
    xdg-user-dirs
    zathura

    (aspellWithDicts (dicts: with dicts; [ en en-computers ]))

    #lsp
    nixpkgs-unstable.bash-language-server
    nixpkgs-unstable.emacs-lsp-booster
    nixpkgs-unstable.lua-language-server
    nixpkgs-unstable.metals
    nixpkgs-unstable.nixd
    nixpkgs-unstable.ltex-ls-plus
    nixpkgs-unstable.pyrefly
    nixpkgs-unstable.ty
    nixpkgs-unstable.openscad-lsp
    rass
    nixpkgs-unstable.terraform-ls
    nixpkgs-unstable.texlab
    nixpkgs-unstable.zls

    # enchant2
    cmake
    delve
    dtach
    gcc
    gdb
    ghostscript
    gnumake
    gnuplot
    go
    lldb
    mermaid-cli
    meson
    ninja
    nix-index
    nixpkgs-unstable.rustup
    nodePackages.prettier
    nodejs
    octave
    ruff
    strace
    uv
    valgrind
    zlib
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  programs.man.generateCaches = true;
  news.display = "silent";
}
