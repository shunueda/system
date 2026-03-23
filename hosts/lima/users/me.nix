{
  flake,
  config,
  pkgs,
  ...
}:
{
  imports = [ flake.modules.home.common ];
}
