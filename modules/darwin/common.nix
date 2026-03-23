{ inputs, ... }:
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];
  nix = {
    settings = {
      allow-import-from-derivation = false;
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
        "dynamic-derivations"
      ];
      sandbox = true;
    };
    gc.automatic = true;
  };
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        ghostty-bin = prev.ghostty-bin.overrideAttrs (
          finalAttrs: _prev: {
            version = "1.3.0";
            src = final.fetchurl {
              url = "https://release.files.ghostty.org/${finalAttrs.version}/Ghostty.dmg";
              hash = "sha256-U/6Y5wmCEYAIwDuf2/XfJlUip/22vfoY630NTNMdDMU=";
            };
          }
        );
      })
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

  # TODO move this to homemodule
  programs = {
    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      settings = {
        auto-update = "off";
        link-previews = true;
        mouse-hide-while-typing = true;
        window-save-state = "always";
      };
    };
    git = {
      enable = true;
      settings = {
        init = {
          defaultBranch = "master";
        };
        user = {
          name = "Shun Ueda";
          email = "me@shu.nu";
        };
        diff.algorithm = "histogram";
        rebase = {
          autosquash = true;
          autostash = true;
          stat = true;
        };
        merge.directoryRenames = true;
        rerere = {
          autoupdate = true;
          enabled = true;
        };
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "github.com" = {
          user = "git";
          identityFile = config.sops.secrets.id_ed25519_github.path;
        };
      };
    };
  };
  home.packages = with pkgs; [
    maccy
    orbstack
  ];
  sops = {
    age = {
      keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      sshKeyPaths = [ ];
    };
    gnupg.sshKeyPaths = [ ];
    defaultSopsFile = ../../secrets/default.yaml;
    secrets = {
      id_ed25519_github = { };
      id_ed25519_oyasai = { };
    };
  };

}
