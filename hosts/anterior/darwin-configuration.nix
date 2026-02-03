{ flake, ... }:
let
  user = "me";
in
{
  imports = with flake.modules.darwin; [
    common
    linux-builder
  ];
  users.users.${user}.home = "/Users/${user}";
  system.primaryUser = user;
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
  };

  # ‼️ State version must stay at the version originally installed.
  system.stateVersion = 6;
  home-manager.users.${user}.home.stateVersion = "25.11";
}
