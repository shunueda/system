{ flake, ... }:
{
  imports = [
    flake.modules.home.common
    ../../../programs/ensure-jupyter-no-output.nix
  ];
  programs = {
    ensure-jupyter-no-output.enable = true;
  };
}
