{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      carlito
      fira-sans
      nerd-fonts.sauce-code-pro
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      source-han-mono
      source-han-sans
      source-han-serif
      unifont
      unifont_upper
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Fira Sans"
          "Source Han Sans"
        ];
        sansSerif = [
          "Fira Sans"
          "Source Han Sans"
        ];
        monospace = [
          "SauceCodePro NFM"
          "Source Han Mono"
        ];
      };
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      (pass-wayland.withExtensions (exts: with exts; [ pass-otp ]))

      (pkgs.python3.withPackages (
        python-pkgs: with python-pkgs; [
          i3ipc
          argparse
        ]
      ))

      cliphist
      foot
      glib
      grim
      inotify-tools
      kanshi
      kdePackages.breeze
      libnotify
      light
      lxmenu-data
      networkmanagerapplet
      papirus-maia-icon-theme
      pavucontrol
      pcmanfm
      playerctl
      pulseaudio
      qjackctl
      rofi
      shared-mime-info
      slurp
      swappy
      sway-audio-idle-inhibit
      sway-new-workspace
      swaycons
      swayest-workstyle
      swayidle
      swaynotificationcenter
      waybar
      waypipe
      wayvnc
      wf-recorder
      wl-clipboard
      wlroots
      wlsunset
      wtype
      xarchiver
    ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway --user-menu --user-menu-min-uid 1000 --remember --remember-session --asterisks";
        user = "greeter";
      };
    };
  };

  services.playerctld.enable = true;

  services.input-remapper.enable = true;

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  programs.dconf.enable = true;
  programs.light.enable = true;

  environment.sessionVariables = {
    GTK_CSD = "0";
    NIXOS_OZONE_WL = "1";
    XDG_CURRENT_DESKTOP = "sway";
    _JAVA_AWT_WM_NONREPARENTING = "1";

    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    # QT_QPA_PLATFORM_PLUGIN_PATH = "${qtPackage.qtbase}/lib/qt-6/plugins/platforms";
    # XMODIFIERS = "@im=fcitx";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    QT_IM_MODULES = "fcitx";
    # INPUT_METHOD = "fcitx";

    # WLR_NO_HARDWARE_CURSORS = "1";
  };
}
