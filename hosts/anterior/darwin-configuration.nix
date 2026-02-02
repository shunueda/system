{ flake, ... }:
{
  imports = [
    flake.modules.darwin.common
    flake.modules.darwin.anterior
  ];
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
  };
}
