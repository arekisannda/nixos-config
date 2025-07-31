{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      fira-sans
      nerd-fonts.sauce-code-pro
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      source-han-mono
      source-han-sans
      source-han-serif
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Fira Sans" "Source Han Sans" ];
        sansSerif = [ "Fira Sans" "Source Han Sans" ];
        monospace = [ "SauceCodePro NFM" "Source Han Mono"];
      };
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      (pass-wayland.withExtensions (exts: with exts; [ pass-otp ]))

      alacritty
      cameractrls
      cliphist
      glib
      grim
      imv
      inotify-tools
      kanshi
      kdePackages.breeze
      lan-mouse
      libnotify
      light
      networkmanagerapplet
      papirus-maia-icon-theme
      pavucontrol
      pcmanfm
      playerctl
      pulseaudio
      qjackctl
      rofi-wayland
      slurp
      swappy
      sway-new-workspace
      swaycons
      swayest-workstyle
      swayidle
      swaylock-effects
      swaynotificationcenter
      vlc
      waybar
      waypipe
      wayvnc
      wf-recorder
      wl-clipboard
      wlroots
      wlsunset
      zathura
    ];
  };

  programs.dconf.enable = true;
  programs.light.enable = true;

  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    environment = {
      WAYLAND_DISPLAY = "wayland-1";
      DISPLAY = ":0";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c $HOME/.config/kanshi/config'';
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway --user-menu --user-menu-min-uid 1000 --remember --remember-session --asterisks";
        user = "greeter";
      };
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  environment.sessionVariables = {
    PATH="/run/current-system/sw/bin:$PATH";
    CALIBRE_USE_DARK_PALETTE = "1";
    GTK_CSD = "0";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XDG_CURRENT_DESKTOP = "sway";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # WLR_NO_HARDWARE_CURSORS = "1";
  };
}
