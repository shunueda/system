{ inputs, pkgs, ... }:
let
  # TODO: from config
  user = "me";
  system = "aarch64-darwin";
in
{
  flake.darwinModules.common = {
    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      gc.automatic = true;
    };
    nixpkgs = {
      hostPlatform = system;
      config.allowUnfree = true;
    };
    users.knownUsers = [ user ];
    users.users.${user} = {
      uid = 501;
      home = "/Users/${user}";
      shell = pkgs.bash;
    };
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    system = {
      primaryUser = user;
      stateVersion = 6;
      defaults = {
        LaunchServices.LSQuarantine = false;
        NSGlobalDomain = {
          AppleShowAllExtensions = true;
          KeyRepeat = 1;
          InitialKeyRepeat = 15;
        };
        dock = {
          show-recents = false;
          autohide = true;
          orientation = "bottom";
          tilesize = 32;
        };
      };
      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToControl = true;
      };
    };
    security.pam.services.sudo_local.touchIdAuth = true;
    home-manager.users.${user} =x
  };
}
