{ inputs, ... }:
{
  flake.darwinModules.common =
    { ... }:
    {
      imports = [ inputs.home-manager.darwinModules.home-manager ];
      nix = {
        settings = {
          allow-import-from-derivation = false;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          sandbox = false;
          substituters = [
            "https://nix-cache.oyasai.io"
            "https://anterior-public.cachix.org"
          ];
          trusted-public-keys = [
            "oyasaiserver:f0coAsRP8jLzDTOmVCY8hqQibMHtZcxjk60oVCQkjtU="
            "anterior-public.cachix.org-1:uLNXTMrqtMCiIJ4lYu47MGrbVPpyploI6J2y5Yre9es="
          ];
        };
        gc.automatic = true;
      };
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [
          (
            final: prev:
            let
              inherit (final.stdenv.hostPlatform) system;
            in
            {
              # https://github.com/NixOS/nixpkgs/issues/507531
              # Possible cause: https://github.com/NixOS/nixpkgs/issues/208951
              direnv = prev.direnv.overrideAttrs (_: {
                doCheck = false;
              });

              # Steam in nixpkgs doesn't support darwin
              inherit
                (import inputs.nixpkgs-steam {
                  inherit system;
                  config.allowUnfree = true;
                })
                steam
                ;

              inherit (inputs.nixpkgs-unstable.legacyPackages.${system})
                # Majutsu requires version in unstable
                jujutsu
                # Broken in 25.11: https://github.com/NixOS/nixpkgs/issues/511265
                jetbrains-mono
                ;
            }
          )
        ];
      };
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      system = {
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
    };
}
