{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      fcitx5-with-addons = pkgs.qt6Packages.fcitx5-with-addons;
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-configtool
        fcitx5-gtk
        fcitx5-hangul
        fcitx5-mozc-ut
      ];

      settings = {
        globalOptions = {
          Behavior = {
            ActiveByDefault = false;
            AllowInputMethodForPassword = false;
            AutoSavePeriod = 30;
            CompactInputMethodInformation = true;
            DefaultPageSize = 5;
            OverrideXkbOption = false;
            PreeditEnabledByDefault = true;
            PreloadInputMethod = true;
            ShareInputState = "All";
            ShowFirstInputMethodInformation = true;
            ShowInputMethodInformation = true;
            ShowPreeditForPassword = false;
            resetStateWhenFocusIn = "no";
            showInputMethodInformationWhenFocusIn = false;
          };
          Hotkey = {
            TriggerKeys = "";
            EnumerateWithTriggerKeys = true;
            EnumerateBackwardKeys = "";
            EnumerateSkipFirst = false;
            EnumerateGroupForwardKeys = "";
            EnumerateGroupBackwardKeys = "";
            ActivateKeys = "";
            DeactivateKeys = "";
            TogglePreedit = "";
            ModifierOnlyKeyTimeout = 250;
          };
          "Hotkey/AltTriggerKeys"."0" = "Hangul_Hanja";
          "Hotkey/EnumerateForwardKeys"."0" = "Shift+Hangul_Hanja";
          "Hotkey/PrevPage"."0 " = "Up";
          "Hotkey/NextPage"."0" = "Down";
          "Hotkey/PrevCandidate"."0" = "Shift+Tab";
          "Hotkey/NextCandidate"."0" = "Tab";
        };
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "mozc";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "mozc";
          "Groups/0/Items/2".Name = "hangul";
        };
        addons = {
          classicui.globalSection = {
            "Vertical Candidate List" = false;
            WheelForPaging = false;
            Font = "Source Han Sans JP 9";
            MenuFont = "Source Han Sans JP 9";
            TrayFont = "Source Han Sans JP Bold 9";
            TrayOutlineColor = "#000000";
            TrayTextColor = "#ffffff";
            PreferTextIcon = false;
            ShowLayoutNameInIcon = true;
            UseInputMethodLanguageToDisplayText = true;
            Theme = "default-dark";
            DarkTheme = "default-dark";
            UseDarkTheme = true;
            UseAccentColor = true;
            PerScreenDPI = false;
            ForceWaylandDPI = 0;
            EnableFractionalScale = true;
          };

          clipboard.globalSection = {
            TriggerKey = "";
            PastePrimary = "";
            "Number of entries" = 5;
          };

          keyboard = {
            globalSection = {
              PageSize = 5;
              PrevCandidate = "";
              NextCandidate = "";
              EnableEmoji = false;
              EnableQuickPhraseEmoji = false;
              "Choose Modifier" = "None";
              EnableHintByDefault = false;
              "Hint Trigger" = "";
              "One Time Hint Trigger" = "";
              UseNewComposeBehavior = true;
              EnableLongPress = false;
            };

            sections = {
              LongPressBlocklist."0" = "konsole";
            };
          };

          hangul = {
            globalSection = {
              Keyboard="Romaja";
              PrevPage = "";
              NextPage = "";
              AutoReorder = false;
              WordCommit = false;
              HanjaMode = false;
            };

            sections = {
              HanjaModeToggleKey."0" = "Henkan";
              PrevCandidate."0"="Shift+Tab";
              NextCandidate."0" = "Tab";
            };
          };

          mozc.globalSection = {
            InitialMode = "Hiragana";
            InputState = "All";
            Vertical = true;
            ExpandMode = "Always";
            PreeditCursorPositionAtBeginning = false;
            ExpandKey = "";
          };

          wayland.globalSection = {
            "Allow Overriding System XKB Settings" = true;
          };

          xcb.globalSection = {
            "Allow Overriding System XKB Settings" = true;
            AlwaysSetToGroupLayout = true;
          };
        };
      };
    };
  };
}
