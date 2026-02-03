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
}
