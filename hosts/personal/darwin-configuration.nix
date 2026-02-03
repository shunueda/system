{ flake, ... }:
let
  user = "me";
in
{
  imports = [ flake.modules.darwin.common ];
  users.users.${user}.home = "/Users/${user}";
  system.primaryUser = user;
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
  };
}
