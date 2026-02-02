{ flake, ... }:
{
  imports = [ flake.modules.darwin.common ];

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
  };
}
