{
  config,
  pkgs,
  nixpkgs-unstable,
  custompkgs,
  stateVersion,
  ...
}@attr:

let
  username = "arekisannda";
  homeDirectory = "/home/${username}";
  importWithArgs = path: import path attr;
in
{
  setup = {
    terminal = {
      type = "xterm-256color";
      theme = import ../../../shared/themes/term/monokai-pro.nix;
    };

    gui = {
      theme = import ../../../shared/themes/gui/yaru-grey.nix;

      wallpaper = {
        image = "$XDG_CONFIG_HOME/swaybg/gruvbox_cave.png";
        color = "#282828";
        scaling = "center";
        lockscreenColor = "#282828";
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
    (importWithArgs ../configs/mime)
    (importWithArgs ../configs/git)
    (importWithArgs ../configs/firefox)
    (importWithArgs ../configs/gpg-agent)
    (importWithArgs ../configs/dconf)
    (importWithArgs ../configs/qt)
    (importWithArgs ../configs/foot)
    (importWithArgs ../configs/fzf)
    (importWithArgs ../configs/gh)
    (importWithArgs ../configs/ripgrep)
    (importWithArgs ../configs/swaylock)
    (importWithArgs ../configs/hyprlock)
    (importWithArgs ../configs/swayr)
    (importWithArgs ../configs/tmux)
    (importWithArgs ../configs/zsh)
    (importWithArgs ../configs/swayidle)
    (importWithArgs ../configs/swaync)
    (importWithArgs ../configs/rofi)
    (importWithArgs ../configs/sway)
    (importWithArgs ../configs/kvantum)
    (importWithArgs ../configs/themes)
    (importWithArgs ../configs/fcitx)
    (importWithArgs ../configs/mise)
    (importWithArgs ../configs/direnv)
    (importWithArgs ../configs/emacs)
    (importWithArgs ../configs/neovim)
    (importWithArgs ../configs/latex)
    (importWithArgs ../configs/mpv)
    (importWithArgs ../configs/swappy)
    (importWithArgs ../configs/wayprompt)
    (importWithArgs ../configs/borgmatic)
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
    MISE_IGNORED_CONFIG_PATHS="${config.home.homeDirectory}/.local/mnt";
  };

  home.file =
    let
      session-vars-file = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
    in
    {
      ".profile".text = ''
        [ -f "${session-vars-file}" ] && . "${session-vars-file}"
      '';
    };

  sops.secrets.yt-dlp-cookies.key = "applications/yt-dlp/cookies";
  services.gnome-keyring.enable = true;
  services.protonmail-bridge.enable = true;
  services.protonmail-bridge.extraPackages = with pkgs; [ gnome-keyring ];

  home.packages = with pkgs; [
    anki-bin
    brave
    calibre
    dict
    discord
    exercism
    farge
    gcr
    git-remote-gcrypt
    imagemagick
    imv
    nixpkgs-unstable.claude-agent-acp
    nixpkgs-unstable.claude-code
    nixpkgs-unstable.openscad-unstable
    nixpkgs-unstable.proton-vpn
    polkit_gnome
    readability-cli
    steam
    thunderbird
    transmission_4-gtk
    vial
    vlc
    w3m
    xdg-user-dirs
    yt-dlp
    zathura

    (aspellWithDicts (
      dicts: with dicts; [
        en
        en-computers
      ]
    ))

    #lsp
    custompkgs.action-languageserver
    custompkgs.rass
    nixpkgs-unstable.bash-language-server
    nixpkgs-unstable.emacs-lsp-booster
    nixpkgs-unstable.ltex-ls-plus
    nixpkgs-unstable.lua-language-server
    nixpkgs-unstable.metals
    nixpkgs-unstable.nixd
    nixpkgs-unstable.openscad-lsp
    nixpkgs-unstable.pyrefly
    nixpkgs-unstable.terraform-ls
    nixpkgs-unstable.texlab
    nixpkgs-unstable.ty
    nixpkgs-unstable.yaml-language-server
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
    nixf
    nixfmt
    nodePackages.prettier
    nodejs
    octave
    ruff
    shfmt
    strace
    treefmt
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
