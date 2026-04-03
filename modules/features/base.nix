{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    bc
    binutils
    cacert
    fzf
    git
    gnupg
    htop
    jq
    libtool
    lnav
    lsof
    man-pages
    man-pages-posix
    neovim
    patsh
    pkg-config
    psmisc
    ranger
    rclone
    ripgrep
    shellcheck
    socat
    sqlite
    sshfs
    stow
    tmux
    tree
    unzip
    wget
    yq-go
    zip
    zsh
    zsh-powerlevel10k
  ];

  users.groups.nixos = { };

  environment.variables = {
    EDITOR = "nvim";
  };

  environment.localBinInPath = true;
  programs.nix-ld.enable = true;

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
    XDG_SCREENSHOTS_DIR = "$HOME/Screenshots";
    XDG_DESKTOP_DIR = "$HOME/Desktop";
    XDG_DOWNLOAD_DIR = "$HOME/Downloads";
    XDG_TEMPLATES_DIR = "$HOME/Templates";
    XDG_PUBLICSHARE_DIR = "$HOME/Public";
    XDG_DOCUMENTS_DIR = "$HOME/Documents";
    XDG_MUSIC_DIR = "$HOME/Music";
    XDG_PICTURES_DIR = "$HOME/Pictures";
    XDG_VIDEOS_DIR = "$HOME/Videos";
  };
}
