{ inputs, pkgs, ... }:
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc.automatic = true;
  };
  nixpkgs = {
    config.allowUnfree = true;
  };
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  system = {
    stateVersion = 6;
    startup.chime = false;
    defaults = {
      LaunchServices.LSQuarantine = false;
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        KeyRepeat = 1;
        InitialKeyRepeat = 15;
      };
      WindowManager.StandardHideWidgets = true;
      dock = {
        show-recents = false;
        autohide = true;
        orientation = "bottom";
        tilesize = 32;
        static-only = true;
      };
      CustomSystemPreferences = {
        "com.apple.finder" = {
          ShowHardDrivesOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
          ShowExternalHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = false;
        };
        "com.apple.Safari" = {
          IncludeDevelopMenu = true;
        };
        "com.apple.desktopservices" = {
          DSDontWriteUSBStores = true;
          DSDontWriteNetworkStores = true;
        };
        "com.apple.AdLib" = {
          forceLimitAdTracking = true;
          allowApplePersonalizedAdvertising = false;
          allowIdentifierForAdvertising = false;
        };
      };
      CustomUserPreferences = {
        "com.apple.HIToolbox" = {
          AppleFnUsageType = 1;
          AppleEnabledInputSources = [
            {
              InputSourceKind = "Keyboard Layout";
              "KeyboardLayout ID" = 0;
              "KeyboardLayout Name" = "U.S.";
            }
            {
              "Bundle ID" = "com.apple.inputmethod.Kotoeri.RomajiTyping";
              InputSourceKind = "Keyboard Input Method";
            }
          ];
        };
        "com.apple.inputmethod.Kotoeri" = {
          JIMPrefLiveConversionKey = 0;
        };
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
  security.pam.services.sudo_local.touchIdAuth = true;
}
